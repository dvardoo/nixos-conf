{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../modules/user.nix
      ../../modules/shell.nix
      ../../modules/common.nix
      #../../modules/workstations.nix
      #../../modules/gaming.nix
      ../../modules/ssh.nix
      ../../modules/gc.nix
      ../../modules/amdrocm.nix
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
