{ config, pkgs, inputs, ... }:
{
  services.xserver.videoDrivers = ["amdgpu"];

  hardware.graphics = {
     enable = true;
     enable32Bit = true;
   };

  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;
  programs.gamemode.enable = true;

  environment.systemPackages = with pkgs; [
    #mangohud
    protonup-ng
    heroic
    lutris
  ];
 
}
