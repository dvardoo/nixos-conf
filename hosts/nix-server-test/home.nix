{ config, pkgs, ... }:

{
  imports = [
    ../../modules/home-manager/shared-home.nix  
  ];

  home.packages = [
    # pkgs.hello
  ];

  home.sessionVariables = {
    # EDITOR = "emacs";
  };
}
