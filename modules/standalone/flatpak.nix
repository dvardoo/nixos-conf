{ config, pkgs, ... }:

{
  services.flatpak.enable = true;

  environment.systemPackages = with pkgs; [
    #cosmic-store
    #gnome-software
    bazaar
  ];

  # Add Flathub remote
  systemd.services.flatpak-setup = {
    wantedBy = [ "multi-user.target" ];
    after = [ "flatpak.service" ];
    serviceConfig.Type = "oneshot";
    script = ''
      ${pkgs.flatpak}/bin/flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    '';
  };

  # Auto-update + cleanup
  systemd.timers.flatpak-update = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "1h";
      OnUnitActiveSec = "1d";
      Persistent = true;
    };
  };

  systemd.services.flatpak-update = {
    serviceConfig.Type = "oneshot";
    script = ''
      ${pkgs.flatpak}/bin/flatpak update -y --appstream
      ${pkgs.flatpak}/bin/flatpak uninstall --unused -y
    '';
  };
}
