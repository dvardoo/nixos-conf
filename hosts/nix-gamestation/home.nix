{ config, pkgs, ... }:

{
  imports = [
    ../../modules/home-manager/shared-home.nix  
  ];

  home.packages = with pkgs; [
    # hello
  ];

  home.sessionVariables = {
    # EDITOR = "emacs";
  };
}
