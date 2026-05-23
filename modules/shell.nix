{ ... }:
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
      ll = "eza -l --icons --group-directories-first";
      la = "eza -la --icons --group-directories-first";
      tree = "eza --icons --tree --group-directories-last";
      needs-reboot = ''if diff <(readlink /run/booted-system/{initrd,kernel,kernel-modules}) <(readlink /nix/var/nix/profiles/system/{initrd,kernel,kernel-modules}); then echo "✓ No reboot needed"; else echo "↻ Reboot needed"; fi'';
      update = "cd ~/nixos-conf/ && git pull && sudo nixos-rebuild switch --flake .#$(hostname)";
      open = "xdg-open";
    };

    histSize = 10000;
    histFile = "$HOME/.zsh_history";
    setOptions = [
      "HIST_IGNORE_ALL_DUPS"
    ];
  };

}
