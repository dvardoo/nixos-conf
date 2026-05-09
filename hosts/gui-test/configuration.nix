{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../modules/default-lite.nix
      #inputs.home-manager-unstable.nixosModules.default
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  #boot.initrd.luks.devices."luks-af259881-0856-45d7-acba-f5cfc410dc2b".device = "/dev/disk/by-uuid/af259881-0856-45d7-acba-f5cfc410dc2b"; #TEST
  networking.hostName = "gui-test"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  #home-manager = {
    # pass inputs to home-manager modules
    #extraSpecialArgs = { inherit inputs; };
    #useUserPackages = true;
    #useGlobalPkgs = true;
    #backupFileExtension = "hm-backup";
    #users = {
    #  "dvardo" = import ./home.nix;
    #};
  #};

  system.stateVersion = "25.05"; # Did you read the comment?
}
