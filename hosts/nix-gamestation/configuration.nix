# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../modules/user.nix
      ../../modules/common.nix
      #../../modules/workstations.nix
      #../../modules/gaming.nix
      ../../modules/ssh.nix
      ../../modules/qemu-guest-agent.nix
      #inputs.home-manager-unstable.nixosModules.default
    ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  networking.hostName = "nix-gamestation"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

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
      user = "deck";
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
