# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../modules/common.nix
      ../../modules/workstations.nix
      inputs.home-manager.nixosModules.default
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  #boot.initrd.luks.devices."luks-af259881-0856-45d7-acba-f5cfc410dc2b".device = "/dev/disk/by-uuid/af259881-0856-45d7-acba-f5cfc410dc2b"; #TEST
  networking.hostName = "nix-thinkpad"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes"];

  # Enable networking
  networking.networkmanager.enable = true;

  # hashcat / games
  #hardware.graphics.extraPackages = with pkgs; [
  #  rocmPackages.clr.icd
  #];


  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.dvardo = {
    isNormalUser = true;
    description = "dvardo";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  home-manager = {
    # pass inputs to home-manager modules
    extraSpecialArgs = { inherit inputs; };
    users = {
      "dvardo" = import ./home.nix;
    };
  };

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  wget
  #  nix-search-cli
    keepassxc
    authenticator
    veracrypt
    nextcloud-client
    wireguard-tools
    kitty
    alacritty
    tmux
    hashcat
    nmap
    #bpftune # Not working?
    #flameshot
    #signal check up
    discord
    #steam needs service?
    #lutris check up
    #heroiclauncher check up
    #somekindofminecraft launcher ?
    #clamscan?
    virt-viewer
    scrcpy
    vscodium-fhs
   # Unstable packages
   #unstable.packagename
    #unstable.srccpy
  ];

  programs.kdeconnect.enable = true;

  system.stateVersion = "25.05"; # Did you read the comment?

}
