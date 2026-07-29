{ pkgs, ... }:

let
  notifyAnyUser = pkgs.writeShellScript "notify-any-user" ''
    set -eu

    TITLE="$1"
    MESSAGE="$2"

    log() {
      echo "notify-any-user: $*" | ${pkgs.systemd}/bin/systemd-cat -t notify-any-user -p info
    }

    warn() {
      echo "notify-any-user: $*" | ${pkgs.systemd}/bin/systemd-cat -t notify-any-user -p warning
    }

    TMP_SESSIONS="$(${pkgs.coreutils}/bin/mktemp)"
    TMP_SENT="$(${pkgs.coreutils}/bin/mktemp)"
    trap '${pkgs.coreutils}/bin/rm -f "$TMP_SESSIONS" "$TMP_SENT"' EXIT

    : > "$TMP_SENT"

    ${pkgs.systemd}/bin/loginctl list-sessions --no-legend --no-pager \
      | ${pkgs.gawk}/bin/awk '$2 ~ /^[0-9]+$/ && $3 != "" { print $1, $2, $3 }' \
      > "$TMP_SESSIONS"

    ${pkgs.gawk}/bin/awk '!seen[$2]++ { print $1, $2, $3 }' "$TMP_SESSIONS" | while read -r SESSION_ID USER_UID USERNAME; do
      [ -n "$SESSION_ID" ] || continue
      [ -n "$USER_UID" ] || continue
      [ -n "$USERNAME" ] || continue

      RUNTIME_DIR="/run/user/$USER_UID"
      BUS="$RUNTIME_DIR/bus"

      log "checking session=$SESSION_ID user=$USERNAME uid=$USER_UID"

      [ -d "$RUNTIME_DIR" ] || { warn "skip $USERNAME: missing $RUNTIME_DIR"; continue; }
      [ -S "$BUS" ] || { warn "skip $USERNAME: missing $BUS"; continue; }

      DISPLAY="$(${pkgs.systemd}/bin/loginctl show-session "$SESSION_ID" -p Display --value 2>/dev/null || true)"
      WAYLAND_DISPLAY="$(${pkgs.systemd}/bin/loginctl show-session "$SESSION_ID" -p WaylandDisplay --value 2>/dev/null || true)"

      export XDG_RUNTIME_DIR="$RUNTIME_DIR"
      export DBUS_SESSION_BUS_ADDRESS="unix:path=$BUS"

      [ -n "$DISPLAY" ] && export DISPLAY
      [ -n "$WAYLAND_DISPLAY" ] && export WAYLAND_DISPLAY

      if ${pkgs.util-linux}/bin/runuser -u "$USERNAME" -- ${pkgs.libnotify}/bin/notify-send -t 10000 -a "NixOS Upgrade" "$TITLE" "$MESSAGE" >/dev/null 2>&1; then
        log "notify-send succeeded for $USERNAME"
        echo 1 > "$TMP_SENT"
      else
        warn "notify-send failed for $USERNAME"
      fi
    done

    if ! echo "$MESSAGE" | ${pkgs.util-linux}/bin/wall >/dev/null 2>&1; then
      warn "wall failed"
    fi

    if [ "$(${pkgs.coreutils}/bin/cat "$TMP_SENT")" = "1" ]; then
      log "at least one desktop notification succeeded"
    else
      warn "no desktop notification succeeded"
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
      ${notifyAnyUser} "Auto-upgrade starting"
    '';

    postStop = ''
      TIMESTAMP=$(${pkgs.coreutils}/bin/date '+%Y-%m-%d %H:%M:%S')
      REBOOT_STATUS=$(if ${pkgs.diffutils}/bin/diff <(readlink /run/booted-system/{initrd,kernel,kernel-modules}) <(readlink /nix/var/nix/profiles/system/{initrd,kernel,kernel-modules}) >/dev/null 2>&1; then echo "✓ No reboot needed"; else echo "↻ Reboot needed"; fi)
      ${notifyAnyUser} "Completed at $TIMESTAMP\n$REBOOT_STATUS"
    '';
  };
}
