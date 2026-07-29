{ pkgs, ... }:


let
  notify-any-user = pkgs.writeShellScript "notify-any-user" ''
    TITLE="$1"
    MESSAGE="$2"
    NOTIFIED=0

    echo "notify-any-user called: $TITLE / $MESSAGE" | ${pkgs.systemd}/bin/systemd-cat -t notify-any-user

    SESSIONS=$(${pkgs.systemd}/bin/loginctl list-sessions --no-legend 2>/dev/null)
    echo "Sessions found: $SESSIONS" | ${pkgs.systemd}/bin/systemd-cat -t notify-any-user

    echo "$SESSIONS" | \
    while read -r SESSION_ID _; do
      [ -z "$SESSION_ID" ] && continue

      SESSION_INFO=$(${pkgs.systemd}/bin/loginctl show-session "$SESSION_ID" \
        -p User -p State -p Type 2>/dev/null)

      USER=$(echo "$SESSION_INFO" | grep '^User=' | cut -d'=' -f2)
      STATE=$(echo "$SESSION_INFO" | grep '^State=' | cut -d'=' -f2)
      TYPE=$(echo "$SESSION_INFO" | grep '^Type=' | cut -d'=' -f2)

      echo "Session $SESSION_ID: User=$USER State=$STATE Type=$TYPE" | ${pkgs.systemd}/bin/systemd-cat -t notify-any-user

      if [ "$STATE" = "active" ] && ([ "$TYPE" = "x11" ] || [ "$TYPE" = "wayland" ]) && [ -n "$USER" ]; then
        user_uid=$(${pkgs.coreutils}/bin/id -u "$USER" 2>/dev/null)
        if [ -n "$user_uid" ] && [ -S "/run/user/$user_uid/bus" ]; then
          echo "Attempting notification to $USER (UID=$user_uid)" | ${pkgs.systemd}/bin/systemd-cat -t notify-any-user

          if ${pkgs.su}/bin/su - "$USER" -c \
            "DBUS_SESSION_BUS_ADDRESS='unix:path=/run/user/$user_uid/bus' \
             ${pkgs.libnotify}/bin/notify-send --urgency=critical '$TITLE' '$MESSAGE'" \
            2>&1 | ${pkgs.systemd}/bin/systemd-cat -t notify-any-user; then
            echo "Notification sent successfully" | ${pkgs.systemd}/bin/systemd-cat -t notify-any-user
            NOTIFIED=1
            break
          fi
        fi
      fi
    done

    if [ $NOTIFIED -eq 0 ]; then
      echo "Falling back to wall" | ${pkgs.systemd}/bin/systemd-cat -t notify-any-user
      echo "NixOS Upgrade: $MESSAGE" | ${pkgs.util-linux}/bin/wall
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
