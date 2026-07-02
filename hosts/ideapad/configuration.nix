{ ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../modules/default-lite.nix
      ../../modules/user-yoyo.nix
      ../../modules/ssh.nix
      #inputs.home-manager-unstable.nixosModules.default
    ];

  # Wi-Fi fix:
  networking.networkmanager.wifi.powersave = false;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  #boot.initrd.luks.devices."luks-af259881-0856-45d7-acba-f5cfc410dc2b".device = "/dev/disk/by-uuid/af259881-0856-45d7-acba-f5cfc410dc2b"; #TEST
  networking.hostName = "ideapad"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  system.stateVersion = "25.05"; # Did you read the comment?
}
