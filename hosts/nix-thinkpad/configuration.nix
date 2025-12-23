# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../modules/common.nix
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

  # Unlock disk GUI, also quiet systemd startup messages
  #boot = {
    # silence first boot output
  #  consoleLogLevel = 3;
  #  initrd.verbose = false;
  #  initrd.systemd.enable = true;
  #  kernelParams = [
  #      "quiet"
  #      "splash"
  #      "intremap=on"
  #      "boot.shell_on_fail"
  #      "udev.log_priority=3"
  #      "rd.systemd.show_status=auto"
  # ];

    # plymouth, showing after LUKS unlock
  #  plymouth.enable = true;
  #  plymouth.font = "${pkgs.hack-font}/share/fonts/truetype/Hack-Regular.ttf";
  #  plymouth.logo = "${pkgs.nixos-icons}/share/icons/hicolor/128x128/apps/nix-snowflake.png";
  #};

  # Performance tuning
  boot.kernelPackages = pkgs.linuxPackages_zen; 
  #services.bpftune.enable = true; # Enable the bpftune service
  #services.bpftune.package = pkgs.bpftune;  # Specify the bpftune package

  # hashcat / games
  #hardware.graphics.extraPackages = with pkgs; [
  #  rocmPackages.clr.icd
  #];

  # Enable COSMIC DE
  services.displayManager.cosmic-greeter.enable = true;
  services.desktopManager.cosmic.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

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
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
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
