{ config, pkgs, inputs, ... }:

{
  imports = [
    ./git.nix
    ./fonts.nix
  ];

  home = {
    username = "dvardo";
    homeDirectory = "/home/dvardo";
    stateVersion = "25.05";

    packages = with pkgs; [
      # User packages for all hosts
      hello
    ];

    sessionVariables = {
      # Common session variables
      # EDITOR = "nvim";
    };
  };
  
  programs.home-manager.enable = true;
}
