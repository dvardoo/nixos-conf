{ config, pkgs, inputs, ... }:

{
  home = {
    username = "dvardo";
    homeDirectory = "/home/dvardo";
    stateVersion = "25.05";

    packages = [
      # Common packages for all hosts
      # pkgs.some-common-package
      pkgs.hello
    ];

    sessionVariables = {
      # Common session variables
      # EDITOR = "nvim";
    };
  };

  programs = {
    home-manager.enable = true;
    # Common program configurations
  };

  # Other common home-manager configurations
}
