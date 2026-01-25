{ pkgs, ... }:

{
  programs.obsidian = {
    enable = true;
    vaults.Notes.target = "Nextcloud/Notes";

    #themes = [ pkgs.obsidian-theme-minimal ];
    #settings = {
    #  theme = "Minimal";
    #};
  };
}
