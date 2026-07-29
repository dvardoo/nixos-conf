{ pkgs, ... }:

let
  notify-any-user = pkgs.writeShellScript "notify-any-user" ''
    TITLE="$1"
    MESSAGE="$2"

    echo "notify-any-user called: $TITLE / $MESSAGE"

    NOTIFIED=0

    ${pkgs.systemd}/bin/loginctl list-sessions | tail -n +2 | while read -r LINE; do
      [ -z "$LINE" ] && continue

      SESSION_ID=$(echo "$LINE" | awk '{print $1}')
      USER_UID=$(echo "$LINE" | awk '{print $2}')
      USERNAME=$(echo "$LINE" | awk '{print $3}')
      CLASS=$(echo "$LINE" | awk '{print $6}')

      # Skip inactive sessions and non-user sessions
      if [ "$CLASS" = "user" ] || [ "$CLASS" = "manager" ]; then
        echo "Session $SESSION_ID: User=$USERNAME UID=$USER_UID Class=$CLASS"

        if [ -n "$USER_UID" ] && [ "$USER_UID" -gt 0 ]; then
          echo "Attempting notification to $USERNAME (UID=$USER_UID)"

          DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$USER_UID/bus" \
          DISPLAY=":0" \
          WAYLAND_DISPLAY="wayland-0" \
          ${pkgs.util-linux}/bin/su - "$USERNAME" -c \
            "${pkgs.libnotify}/bin/notify-send --urgency=critical --expire-time=0 -a 'NixOS Upgrade' '$TITLE' '$MESSAGE'" 2>&1 && NOTIFIED=1
        fi
      fi
    done

    if [ $NOTIFIED -eq 0 ]; then
      echo "No active GUI sessions found, using wall fallback"
      echo "$MESSAGE" | ${pkgs.util-linux}/bin/wall
    else
      echo "Notification sent successfully"
    fi
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
