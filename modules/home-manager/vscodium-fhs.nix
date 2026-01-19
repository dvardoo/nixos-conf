{ config, pkgs, ... }:

{
  home.packages = [ pkgs.nixd ];

  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        jnoortheen.nix-ide
        #catppuccin.catppuccin-vsc
      ];
      userSettings = {
        "nix.serverPath" = "nixd";
        "nix.enableLanguageServer" = true;
        "nixpkgs" = {
          "expr" ="import <nixpkgs> { }";
        };
        "formatting" = {
          "command" = [
            "nixfmt"
          ];
        };
        "nix.formatterPath" = "nixfmt";
        "git.autofetch" = true;
        "update.showReleaseNotes" = false;
      };
    };
  };
}
