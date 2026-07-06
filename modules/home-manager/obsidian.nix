{ ... }:

{
  programs.obsidian = {
    enable = true;
    vaults.Notes.target = "Nextcloud/Notes";

    #themes = [ pkgs.obsidian-theme-minimal ];
    vaults.Notes.settings.appearance = {
         theme = "system";
    };
  };
}
