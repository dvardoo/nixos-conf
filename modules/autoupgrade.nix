{ pkgs, ... }:

let
  notify-any-user = pkgs.writeShellScript "notify-any-user" ''
    TITLE="$1"
    MESSAGE="$2"

    NOTIFIED_FILE=$(${pkgs.coreutils}/bin/mktemp)
    echo 0 > "$NOTIFIED_FILE"

    ${pkgs.systemd}/bin/loginctl list-sessions | awk 'NR > 1 && $6 == "user" {print $2, $3}' | while read -r USER_UID USERNAME; do
      if [ -n "$USER_UID" ] && [ "$USER_UID" -gt 0 ]; then
        echo "notify-any-user: Attempting notification to $USERNAME (UID=$USER_UID)" | ${pkgs.systemd}/bin/systemd-cat -t notify-any-user

        SESSION_INFO=$(${pkgs.systemd}/bin/loginctl show-session -p Display,WaylandDisplay --value $(${pkgs.systemd}/bin/loginctl list-sessions | awk -v uid="$USER_UID" '$2 == uid {print $1; exit}'))
        DISPLAY=$(echo "$SESSION_INFO" | head -1)
        WAYLAND_DISPLAY=$(echo "$SESSION_INFO" | tail -1)

        [ -z "$DISPLAY" ] && DISPLAY=":0"
        [ -z "$WAYLAND_DISPLAY" ] && WAYLAND_DISPLAY="wayland-0"

        DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$USER_UID/bus" \
        XDG_RUNTIME_DIR="/run/user/$USER_UID" \
        DISPLAY="$DISPLAY" \
        WAYLAND_DISPLAY="$WAYLAND_DISPLAY" \
        ${pkgs.util-linux}/bin/runuser -u "$USERNAME" -- \
          ${pkgs.libnotify}/bin/notify-send -t 0 -a 'NixOS Upgrade' "$TITLE" "$MESSAGE" 2>&1 && echo 1 > "$NOTIFIED_FILE"
      fi
    done

    NOTIFIED=$(cat "$NOTIFIED_FILE")
    ${pkgs.coreutils}/bin/rm "$NOTIFIED_FILE"

    if [ "$NOTIFIED" -eq 0 ]; then
      echo "notify-any-user: No active GUI sessions found, using wall fallback" | ${pkgs.systemd}/bin/systemd-cat -t notify-any-user
      echo "$MESSAGE" | ${pkgs.util-linux}/bin/wall
    else
      echo "notify-any-user: Notification sent successfully" | ${pkgs.systemd}/bin/systemd-cat -t notify-any-user
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
