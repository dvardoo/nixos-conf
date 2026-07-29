{ pkgs, ... }:


let
  notify-any-user = pkgs.writeShellScript "notify-any-user" ''
    TITLE="$1"
    MESSAGE="$2"

    # Try to send D-Bus notification to any logged-in user
    for pid in $(${pkgs.procps}/bin/pgrep -u 1000-9999 systemd 2>/dev/null); do
      # Extract DBUS address from the systemd process environment
      DBUS_ADDR=$(${pkgs.coreutils}/bin/tr '\0' '\n' < /proc/$pid/environ 2>/dev/null | \
        ${pkgs.gnugrep}/bin/grep '^DBUS_SESSION_BUS_ADDRESS=' | \
        ${pkgs.coreutils}/bin/cut -d'=' -f2)

      if [ -n "$DBUS_ADDR" ]; then
        # Send notification using the extracted DBUS address
        DBUS_SESSION_BUS_ADDRESS="$DBUS_ADDR" \
        ${pkgs.dbus}/bin/dbus-send \
          --print-reply \
          --dest=org.freedesktop.Notifications \
          /org/freedesktop/Notifications \
          org.freedesktop.Notifications.Notify \
          string:"$TITLE" \
          uint32:0 \
          string:"" \
          string:"$TITLE" \
          string:"$MESSAGE" \
          array:string: \
          dict:string:variant:urgency,byte:1 \
          int32:5000 2>/dev/null && exit 0
      fi
    done

    # Fallback to wall
    ${pkgs.util-linux}/bin/wall "⚠ $TITLE: $MESSAGE"
  '';
in

{
  system.autoUpgrade = {
    enable = true;
    dates = "03:00";
    flake = "github:dvardoo/nixos-conf";
    allowReboot = false;
    randomizedDelaySec = "30min";
    flags = [
      "--no-write-lock-file"
      "--max-jobs" "2"
      "--cores" "2"
    ];
    persistent = true;
  };

  systemd.services.nixos-upgrade = {
    serviceConfig = {
      CPUSchedulingPolicy = "idle";
      IOSchedulingClass = "idle";
    };

    preStart = ''
      ${notify-any-user} "NixOS Upgrade" "Auto-upgrade starting"
    '';

    postStop = ''
      TIMESTAMP=$(${pkgs.coreutils}/bin/date '+%Y-%m-%d %H:%M:%S')
      REBOOT_STATUS=$(if ${pkgs.diffutils}/bin/diff <(readlink /run/booted-system/{initrd,kernel,kernel-modules}) <(readlink /nix/var/nix/profiles/system/{initrd,kernel,kernel-modules}) >/dev/null 2>&1; then echo "✓ No reboot needed"; else echo "↻ Reboot needed"; fi)
      ${notify-any-user} "NixOS Upgrade" "Completed at $TIMESTAMP\n$REBOOT_STATUS"
    '';
  };
}
