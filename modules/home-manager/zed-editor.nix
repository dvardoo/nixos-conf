{ config, pkgs, ... }:

{
  programs.zed-editor = {
    enable = true;
    extensions = [ "nix" ];
    userSettings = {
      hour_format = "hour24";
      vim_mode = true;
    };
  };
}
