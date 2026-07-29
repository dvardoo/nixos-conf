{ pkgs, ... }:


let
  notify-any-user = pkgs.writeShellScript "notify-any-user" ''
    TITLE="$1"
    MESSAGE="$2"

    # Get active desktop sessions using loginctl
    ${pkgs.systemd}/bin/loginctl list-sessions --no-legend | \
    while read -r SESSION_ID REST; do
      # Get session details
      SESSION_INFO=$(${pkgs.systemd}/bin/loginctl show-session \
        -p User -p State -p Type -p Display "$SESSION_ID" 2>/dev/null)

      USER=$(echo "$SESSION_INFO" | grep '^User=' | cut -d'=' -f2)
      STATE=$(echo "$SESSION_INFO" | grep '^State=' | cut -d'=' -f2)
      TYPE=$(echo "$SESSION_INFO" | grep '^Type=' | cut -d'=' -f2)

      # Only notify active X11/Wayland sessions
      if [ "$STATE" = "active" ] && ([ "$TYPE" = "x11" ] || [ "$TYPE" = "wayland" ]) && [ -n "$USER" ]; then
        # Get the user's UID
        UID=$(${pkgs.coreutils}/bin/id -u "$USER" 2>/dev/null)
        if [ -n "$UID" ]; then
          DBUS_ADDR="unix:path=/run/user/$UID/bus"

          # Run notify-send as the user using su (no sudo required)
          ${pkgs.su}/bin/su -l "$USER" -c \
            "${pkgs.coreutils}/bin/env DBUS_SESSION_BUS_ADDRESS='$DBUS_ADDR' \
            ${pkgs.libnotify}/bin/notify-send \
              --urgency=critical \
              '$TITLE' '$MESSAGE'" 2>/dev/null && exit 0
        fi
      fi
    done

    # Fallback to wall if no notifications sent
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
