{ ... }:

{
  imports =
    [
      ./user.nix
      ./shell.nix
      ./cosmic.nix
      ./boot.nix
      ./common.nix
      ./common-gui.nix
      ./performance.nix
      ./gaming.nix
      ./gc.nix
      ./autoupgrade.nix
      ./amdrocm.nix
      ./llm.nix
      ./stylix.nix
      ./overlays.nix
    ];

}
