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

  jovian = {
    # Steam-specific settings
    steam = {
      autoStart = true;  # Automatically start Steam
      #enableGameMode = true;  # Enable Steam's game mode
      #showNotifications = true;  # Show Steam notifications
    };

    # Power and performance settings
   # power = {
   #   enableGameMode = true;  # Optimize power for gaming
   #   preferGamePerformance = true;  # Prioritize game performance
   #   batteryThresholdCharging = 80;  # Battery charge limit
   # };

    # Controller configuration
    #controller = {
    #  enableSteamInput = true;  # Use Steam Input
    #  enableGyro = true;  # Enable gyroscope support
    #  enableHaptics = true;  # Enable controller haptics
    #};

    # Display and UI settings
    #ui = {
    #  enableGameMode = true;  # Optimize UI for gaming
    #  scaleFactor = 1.0;  # UI scaling
    #  enableGameScoped = true;  # Game-specific UI adjustments
    #};
  };

  # Enable xbox controllers  
  hardware.xone.enable = true;

  system.stateVersion = "25.05"; # Did you read the comment?
}
