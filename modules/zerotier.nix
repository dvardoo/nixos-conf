{ pkgs, lib, ... }:

{
  services.zerotierone = {
    enable = true;
  };

  systemd.services."zerotier-one" = {
      wantedBy = lib.mkForce [ "multi-user.target" ];
      enable = lib.mkForce false;
  };
}
