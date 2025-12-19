{ config, pkgs, ... }:

{
  # Define user-specific settings here
  home.packages = with pkgs; [
    # List of packages to install for the user
    firefox
    #neovim
    # Add any other packages you want
  ];

  # Enable specific programs
  programs.zsh.enable = true;
  programs.zsh.ohMyZsh.enable = true;

  # Add any other configurations you need
}
