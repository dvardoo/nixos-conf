{ config, pkgs, ... }:

{
  imports = [
    #../../modules/home-manager/shared-home.nix  
  ];

  home = {
    username = "dvardo";
    homeDirectory = "/home/dvardo";
    stateVersion = "25.05";
  };

  home.packages = with pkgs; [
    # hello
  ];

  home.sessionVariables = {
    # EDITOR = "emacs";
  };
}
