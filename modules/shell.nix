{ config, pkgs, inputs, ... }:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    ohMyZsh = {
      enable = true;
      plugins = [
        "git"
        #"docker"
      ];
      theme = "juanghurtado"; 
    };

    shellAliases = {
      ll = "eza -l --icons";
      update = "cd ~/nixos-conf/ && git pull && sudo nixos-rebuild switch --flake .#$(hostname)";
    };

    histSize = 10000;
    histFile = "$HOME/.zsh_history";
    setOptions = [
      "HIST_IGNORE_ALL_DUPS"
    ];
  };

}
