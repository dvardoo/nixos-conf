{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      # System
      ../../modules/shared/system/user.nix
      ../../modules/shared/system/shell.nix
      ../../modules/shared/system/common.nix
      ../../modules/shared/system/gc.nix

      # Services
      ../../modules/shared/services/ssh.nix

      # UI
      ../../modules/shared/ui/stylix.nix
      #inputs.home-manager-unstable.nixosModules.default
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "gamestation"; # Define your hostname.

  home-manager = {
    # pass inputs to home-manager modules
    extraSpecialArgs = { inherit inputs; };
    users = {
      "dvardo" = import ./home.nix;
    };
  };

  # Wayland and Gamescope Session Configuration
  services.displayManager = {
    enable = true;
    # Use Gamescope as the primary session
    defaultSession = "gamescope-wayland";
  };

  # Jovian Configuration
  jovian = {
    steam = {
      enable = true;
      autoStart = true;
      desktopSession = "gamescope-wayland";
      user = "dvardo";
    };
  };

  # Steam and Gamescope
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
  };

  programs.gamescope = {
    enable = true;
    #capSysNice = true;
  };

  # Auto-login configuration
  services.getty.autologinUser = "dvardo";

  # Enable xbox controllers
  hardware.xone.enable = true;

  system.stateVersion = "25.05"; # Did you read the comment?
}
