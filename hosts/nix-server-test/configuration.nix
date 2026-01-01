# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../modules/user.nix
      ../../modules/shell.nix
      ../../modules/common.nix
      ../../modules/ssh.nix
      ../../modules/qemu-guest-agent.nix
      #inputs.home-manager.nixosModules.default
    ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  # Set static IP
  #networking.interfaces.ens18.ipv4.addresses = [
  #  {
  #    address = "";
  #    prefixLength = 24;
  #  }
  #];
  #networking.defaultGateway = "";
  #networking.nameservers = [""];
 
  # Use DHCP
  networking.interfaces.ens18.useDHCP = true;

  networking.hostName = "server-test"; # Define your hostname.

  home-manager = {
    # pass inputs to home-manager modules
    extraSpecialArgs = { inherit inputs; };
    users = {
      "dvardo" = import ./home.nix;
    };
  };

  system.stateVersion = "25.05"; # Did you read the comment?
}
