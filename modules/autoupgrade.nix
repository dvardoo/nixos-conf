{ pkgs, ... }:

let
  notify-any-user = pkgs.writeShellScript "notify-any-user" ''
    TITLE="$1"
    MESSAGE="$2"

    NOTIFIED_FILE=$(${pkgs.coreutils}/bin/mktemp)
    echo 0 > "$NOTIFIED_FILE"

    echo "notify-any-user: Starting notification process" | ${pkgs.systemd}/bin/systemd-cat -t notify-any-user -p info

    ${pkgs.systemd}/bin/loginctl list-sessions | awk 'NR > 1 && $6 == "user" {print $2, $3}' | while read -r USER_UID USERNAME; do
      if [ -n "$USER_UID" ] && [ "$USER_UID" -gt 0 ]; then
        echo "notify-any-user: Found user session - $USERNAME (UID=$USER_UID)" | ${pkgs.systemd}/bin/systemd-cat -t notify-any-user -p info

        # Get session ID
        SESSION_ID=$(${pkgs.systemd}/bin/loginctl list-sessions | awk -v uid="$USER_UID" '$2 == uid {print $1; exit}')
        echo "notify-any-user: Session ID for $USERNAME: $SESSION_ID" | ${pkgs.systemd}/bin/systemd-cat -t notify-any-user -p info

        SESSION_INFO=$(${pkgs.systemd}/bin/loginctl show-session -p Display,WaylandDisplay --value "$SESSION_ID")
        DISPLAY=$(echo "$SESSION_INFO" | head -1)
        WAYLAND_DISPLAY=$(echo "$SESSION_INFO" | tail -1)

        echo "notify-any-user: Raw session info: $SESSION_INFO" | ${pkgs.systemd}/bin/systemd-cat -t notify-any-user -p debug
        echo "notify-any-user: DISPLAY=$DISPLAY, WAYLAND_DISPLAY=$WAYLAND_DISPLAY" | ${pkgs.systemd}/bin/systemd-cat -t notify-any-user -p debug

        [ -z "$DISPLAY" ] && DISPLAY=":0"
        [ -z "$WAYLAND_DISPLAY" ] && WAYLAND_DISPLAY="wayland-0"

        echo "notify-any-user: After defaults - DISPLAY=$DISPLAY, WAYLAND_DISPLAY=$WAYLAND_DISPLAY" | ${pkgs.systemd}/bin/systemd-cat -t notify-any-user -p debug

        DBUS_ADDR="unix:path=/run/user/$USER_UID/bus"
        echo "notify-any-user: Using DBUS address: $DBUS_ADDR" | ${pkgs.systemd}/bin/systemd-cat -t notify-any-user -p debug

        NOTIFY_OUTPUT=$(DBUS_SESSION_BUS_ADDRESS="$DBUS_ADDR" \
          XDG_RUNTIME_DIR="/run/user/$USER_UID" \
          DISPLAY="$DISPLAY" \
          WAYLAND_DISPLAY="$WAYLAND_DISPLAY" \
          ${pkgs.util-linux}/bin/runuser -u "$USERNAME" -- \
            ${pkgs.libnotify}/bin/notify-send -t 0 -a 'NixOS Upgrade' "$TITLE" "$MESSAGE" 2>&1)

        NOTIFY_EXIT=$?
        echo "notify-any-user: notify-send exit code: $NOTIFY_EXIT" | ${pkgs.systemd}/bin/systemd-cat -t notify-any-user -p info

        if [ $NOTIFY_EXIT -eq 0 ]; then
          echo "notify-any-user: notify-send output: $NOTIFY_OUTPUT" | ${pkgs.systemd}/bin/systemd-cat -t notify-any-user -p info
          echo 1 > "$NOTIFIED_FILE"
        else
          echo "notify-any-user: notify-send FAILED - output: $NOTIFY_OUTPUT" | ${pkgs.systemd}/bin/systemd-cat -t notify-any-user -p err
        fi
      fi
    done

    NOTIFIED=$(cat "$NOTIFIED_FILE")
    ${pkgs.coreutils}/bin/rm "$NOTIFIED_FILE"

    if [ "$NOTIFIED" -eq 0 ]; then
      echo "notify-any-user: No active GUI sessions found, using wall fallback" | ${pkgs.systemd}/bin/systemd-cat -t notify-any-user -p warning
      echo "$MESSAGE" | ${pkgs.util-linux}/bin/wall
    else
      echo "notify-any-user: Notification sent successfully" | ${pkgs.systemd}/bin/systemd-cat -t notify-any-user -p info
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
