{ ... }:

{
  imports =
    [
      ./user.nix
      ./shell.nix
      ./common.nix
      ./common-gui.nix
      ./cinnamon.nix
      ./gc.nix
      #./performance.nix
      #./overlays.nix
    ];

}
