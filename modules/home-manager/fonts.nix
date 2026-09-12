{ pkgs, ... }:

{
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.fira-mono
    nerd-fonts.jetbrains-mono
    dejavu_fonts
  ];

  fonts.fontconfig = {
    defaultFonts = {
      monospace = [ "JetBrainsMono Nerd Font" "FiraMono Nerd Font" "FiraCode Nerd Font"  ];
      sansSerif = [ "DejaVu Sans" "FiraCode Nerd Font" ];
      serif = [ "DejaVu Serif" "FiraCode Nerd Font" ];
    };
  };
}
