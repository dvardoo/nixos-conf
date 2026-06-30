{ config, pkgs, lib, ... }:

let
  updateScript = pkgs.writeShellScript "nixos-flake-update" ''
    set -e
    cd ~/nixos-conf

    ${pkgs.git}/bin/git pull

    if ${pkgs.findutils}/bin/find flake.lock -mtime +1 -quit; then
      echo "flake.lock is older than 1 day, updating"
      ${pkgs.nix}/bin/nix flake update
    fi

    if ! ${pkgs.nix}/bin/nix flake check; then
      echo "nix flake check failed, reverting flake.lock"
      ${pkgs.git}/bin/git checkout flake.lock
      ${pkgs.libnotify}/bin/notify-send -u critical "NixOS Flake Update" "flake check failed reverted changes"
      exit 1
    fi

    if ! ${pkgs.git}/bin/git diff --quiet flake.lock; then
      echo "Changes detected, committing"
      ${pkgs.git}/bin/git add flake.lock
      ${pkgs.git}/bin/git commit -m "auto flake bump"
      ${pkgs.git}/bin/git push origin main
      ${pkgs.libnotify}/bin/notify-send "NixOS Flake Update" "Successfully updated and pushed flake.lock"
    fi
  '';
in

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
        ExecStart = "${updateScript}";
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
        OnCalendar = "daily";
        Persistent = true;
      };

      Install.WantedBy = [ "timers.target" ];
    };
  };
}
