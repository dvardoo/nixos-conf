{ config, pkgs, inputs, ... }:

{
  imports = [
    ./git.nix
    ./fonts.nix
    #./keepassxc.nix
    ./vscodium-fhs.nix
  ];

  nixpkgs.config.allowUnfree = true;

  home = {
    username = "dvardo";
    homeDirectory = "/home/dvardo";
    stateVersion = "25.05";

    packages = with pkgs; [
      # User packages for all hosts
      # Security
      keepassxc
      authenticator
      veracrypt

      # Tools
      hashcat
      nmap
      bat
      wget
      nix-search-cli
      virt-viewer
      scrcpy
      #vscodium-fhs
      alacritty
      nextcloud-client
      wireguard-tools
      kitty
      tmux
      flameshot
      obsidian

      # Communication
      discord
      signal-desktop

      # Gaming
      #steam needs service?
      #lutris check up
      #heroiclauncher check up
      #somekindofminecraft launcher ?
    ];

    sessionVariables = {
      # Common session variables
      # EDITOR = "nvim";
    };
  };
  
  programs.home-manager.enable = true;
}
