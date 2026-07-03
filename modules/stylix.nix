{ pkgs, ... }:
let
  isDarkMode = true;  # Switch to false for light mode

  darkTheme = "${pkgs.base16-schemes}/share/themes/kanagawa.yaml";

  lightTheme = {
    scheme = "Kanagawa Lotus";
    author = "rebelot";
    base00 = "f1f5f8";
    base01 = "e5ddb0";
    base02 = "dcd5ac";
    base03 = "c8a882";
    base04 = "8a8980";
    base05 = "545464";
    base06 = "3d3b52";
    base07 = "1f1f28";
    base08 = "c84053";
    base09 = "cc6d00";
    base0A = "77713f";
    base0B = "6f894e";
    base0C = "597b75";
    base0D = "4d699b";
    base0E = "766b90";
    base0F = "b35b79";
  };

  activeScheme = if isDarkMode then darkTheme else lightTheme;
in
{
  stylix = {
    enable = true;
    polarity = if isDarkMode then "dark" else "light";
    base16Scheme = activeScheme;
  };
}
