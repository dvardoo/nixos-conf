{ pkgs, lib, ... }:
{
  stylix = {
    enable = true;
    polarity = "dark";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";
    #image = "${pkgs.nixos-logos}/share/logos/nixos-vivid-colors.png";

    targets.gtksourceview.enable = false; # Try to fix slow rebuilds https://github.com/nix-community/stylix/issues/2223
  };

  environment.systemPackages = with pkgs; [
    #numix-icon-theme-circle
    gruvbox-plus-icons
  ];
}
