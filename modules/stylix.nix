{ pkgs, ... }:

{
  stylix = {
    enable = true;
    polarity = "dark";
    #base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-macchiato.yaml";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";
    
    # Use the override option for color customization
    #override = {
    #  base0D = "#A6E3A1";  # green accent
    #};
  };
}
