{ pkgs, lib, ... }:
let
  darkTheme = "${pkgs.base16-schemes}/share/themes/kanagawa.yaml";

  lightTheme = {
    scheme = "Kanagawa Lotus";
    author = "rebelot";
    variant = "light";
    base00 = "f2ecbc";
    base01 = "e5ddb0";
    base02 = "dcd5ac";
    base03 = "c8a882";
    base04 = "8a8980";
    base05 = "43436c";
    base06 = "3d3b52";
    base07 = "1f1f28";
    base08 = "c84053";
    base09 = "cc6d00";
    base0A = "e4c9af";
    base0B = "6f894e";
    base0C = "597b75";
    base0D = "4d699b";
    base0E = "766b90";
    base0F = "b35b79";
  };

  toggleThemeScript = pkgs.writeShellScriptBin "toggle-theme" ''
    if [ ! -f "$HOME/.cache/theme_is_dark" ]; then
      echo "false" > "$HOME/.cache/theme_is_dark"
    fi

    if grep -q "false" "$HOME/.cache/theme_is_dark"; then
      sudo /nix/var/nix/profiles/system/specialisation/dark/bin/switch-to-configuration switch
      echo "true" > "$HOME/.cache/theme_is_dark"
    else
      sudo /nix/var/nix/profiles/system/bin/switch-to-configuration switch
      echo "false" > "$HOME/.cache/theme_is_dark"
    fi
  '';
in
{
  stylix = {
    enable = true;
    polarity = "light";
    base16Scheme = lightTheme;
    image = "${pkgs.nixos-logos}/share/logos/nixos-vivid-colors.png";
  };

  environment.systemPackages = [
    toggleThemeScript
    pkgs.numix-icon-theme-circle
  ];

  specialisation = {
    dark = {
      inheritParentConfig = true;
      configuration = {
        stylix.polarity = lib.mkForce "dark";
        stylix.base16Scheme = lib.mkForce darkTheme;
      };
    };
  };
}
