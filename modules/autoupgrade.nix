{ pkgs, ... }:

let
  notify-any-user = pkgs.writeShellScript "notify-any-user" ''
    set -x
    TITLE="$1"
    MESSAGE="$2"

    # Find PIDs of user systemd instances (UID >= 1000)
    for pid in $(${pkgs.procps}/bin/ps aux | ${pkgs.gnugrep}/bin/grep -E '[s]ystemd.*--user' | ${pkgs.coreutils}/bin/awk '{print $2}'); do
      # Check if the process owner is a regular user (UID >= 1000)
      uid=$(${pkgs.coreutils}/bin/stat -c '%U' /proc/$pid 2>/dev/null)
      [[ "$uid" =~ ^[0-9]+$ ]] && [ "$uid" -ge 1000 ] || continue

      DBUS_ADDR=$(${pkgs.util-linux}/bin/cat /proc/$pid/environ 2>/dev/null | \
        ${pkgs.gnugrep}/bin/grep -z "DBUS_SESSION_BUS_ADDRESS" | \
        ${pkgs.gnugrep}/bin/grep -o "unix:path=[^[:space:]]*")

      DISPLAY=$(${pkgs.util-linux}/bin/cat /proc/$pid/environ 2>/dev/null | \
        ${pkgs.gnugrep}/bin/grep -z "^DISPLAY=" | \
        ${pkgs.gnugrep}/bin/grep -o "=[^[:space:]]*" | \
        ${pkgs.coreutils}/bin/cut -c2-)

      if [ -n "$DBUS_ADDR" ] && [ -S "''${DBUS_ADDR#unix:path=}" ] && [ -n "$DISPLAY" ]; then
        DBUS_SESSION_BUS_ADDRESS="$DBUS_ADDR" \
        ${pkgs.dbus}/bin/dbus-send \
          --session \
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
          int32:5000 \
          2>&1 && exit 0
      fi
    done

    # Fallback to wall
    ${pkgs.util-linux}/bin/wall "$TITLE: $MESSAGE"
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
