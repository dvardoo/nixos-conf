{ config, pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    libnotify
  ];

  systemd.user = {
    services.nixos-flake-update = {
      Unit = {
        Description = "NixOS flake daily update and check";
        After = [ "network-online.target" ];
        Wants = [ "network-online.target" ];
      };
      Service = {
        Type = "oneshot";
        WorkingDirectory = "%h/nixos-conf";
        ExecStart = "${pkgs.bash}/bin/bash -c ''
          set -e

          # Pull latest changes
          ${pkgs.git}/bin/git pull

          # Check if flake.lock is older than 1 day
          if ${pkgs.findutils}/bin/find flake.lock -mtime +1 -quit; then
            echo "flake.lock is older than 1 day, updating..."
            ${pkgs.nix}/bin/nix flake update
          fi

          # Check flake integrity
          if ! ${pkgs.nix}/bin/nix flake check; then
            # Revert on error
            echo "nix flake check failed, reverting flake.lock..."
            ${pkgs.git}/bin/git checkout flake.lock
            ${pkgs.libnotify}/bin/notify-send -u critical "NixOS Flake Update" "flake check failed, reverted changes"
            exit 1
          fi

          # Check if flake.lock has changes
          if ${pkgs.git}/bin/git diff --quiet flake.lock; then
            echo "No changes to flake.lock"
          else
            echo "Changes detected, committing..."
            ${pkgs.git}/bin/git add flake.lock
            ${pkgs.git}/bin/git commit -m "auto: flake bump"
            ${pkgs.git}/bin/git push origin main
            ${pkgs.libnotify}/bin/notify-send "NixOS Flake Update" "Successfully updated and pushed flake.lock"
          fi
        '';
        StandardOutput = "journal";
        StandardError = "journal";
      };
    };

    timers.nixos-flake-update = {
      Unit = {
        Description = "NixOS flake daily update timer";
        After = [ "graphical-session-pre.target" ];
        PartOf = [ "graphical-session.target" ];
      };
      Timer = {
        OnBootSec = "5min";
        OnUnitActiveSec = "1d";
        Persistent = true;
      };
      Install.WantedBy = [ "timers.target" ];
    };
  };
}
