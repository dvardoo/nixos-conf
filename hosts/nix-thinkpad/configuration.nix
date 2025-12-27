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
      ../../modules/workstations.nix
      ../../modules/gaming.nix
      #inputs.home-manager-unstable.nixosModules.default
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  #boot.initrd.luks.devices."luks-af259881-0856-45d7-acba-f5cfc410dc2b".device = "/dev/disk/by-uuid/af259881-0856-45d7-acba-f5cfc410dc2b"; #TEST
  networking.hostName = "nix-thinkpad"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  home-manager = {
    # pass inputs to home-manager modules
    extraSpecialArgs = { inherit inputs; };
    users = {
      "dvardo" = import ./home.nix;
    };
  };

  system.stateVersion = "25.05"; # Did you read the comment?
}
