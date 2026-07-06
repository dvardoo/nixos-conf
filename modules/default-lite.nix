{ ... }:

{
  imports =
    [
      ./user.nix
      ./ssh.nix
      ./shell.nix
      ./common.nix
      ./common-gui.nix
      ./boot.nix
      ./cinnamon.nix
      ./gc.nix
      ./autoupgrade.nix
      ./zramswap.nix
      #./performance.nix
      #./overlays.nix
    ];

}
