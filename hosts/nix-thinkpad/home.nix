{ config, pkgs, ... }:

{
  imports = [
    ../../modules/home-manager/shared-home.nix  
  ];

  home.packages = config.home.packages ++ [
    pkgs.hello
  ];

  home.sessionVariables = config.home.sessionVariables // {
    # EDITOR = "emacs";
  };
}
