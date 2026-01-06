{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    settings = {
      user = {
        email = "67321210+dvardoo@users.noreply.github.com";
        name = "dvardo";
      };

      url = {
        "git@github.com:" = {
          insteadOf = "https://github.com/";
        };
      };

      #push = {
      #  default = "current";
      #  autoSetupRemote = true;
      #};

      #core = {
      #  sshCommand = "ssh -o IdentitiesOnly=yes";
      #};
    };
  };
}
