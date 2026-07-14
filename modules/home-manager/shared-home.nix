{ pkgs, ... }:

{
  imports = [
    ./git.nix
    ./fonts.nix
    #./browsers.nix
    ./keepassxc.nix
    #./keepassxc-wrapped.nix
    ./notifications.nix
    ./update-service.nix
    #../stylix.nix
    ./alacritty.nix
    ./obsidian.nix
    ./zed-editor.nix
  ];

  nixpkgs.config.allowUnfree = true;

  home = {
    username = "dvardo";
    homeDirectory = "/home/dvardo";
    stateVersion = "25.05";

    packages = with pkgs; [
      # User packages for all hosts
      # Security
      #keepassxc
      authenticator
      veracrypt
      yubikey-manager

      # Tools
      hashcat
      nmap
      exploitdb
      dirb
      gobuster
      binwalk
      yara
      bat
      wget
      nix-search-cli
      virt-viewer
      scrcpy
      #alacritty
      nextcloud-client
      wireguard-tools
      kitty
      tmux
      flameshot
      vlc
      onionshare-gui
      drawio
      magic-wormhole
      papers
      pdfgrep
      caligula
      localsend
      unrar
      #obsidian
      texmaker
      texliveFull

      # Communication
      discord
      signal-desktop
      teams-for-linux

      # Gaming
      #steam needs service?
      #lutris check up
      #heroiclauncher check up
      #somekindofminecraft launcher ?

      # Entertainment
      jellyfin-desktop
      finamp
    ];

    sessionVariables = {
      # Common session variables
      # EDITOR = "nvim";
    };
  };

  programs.home-manager.enable = true;
}
