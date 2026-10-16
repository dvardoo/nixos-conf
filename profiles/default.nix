{ ... }:

{
  imports =
    [
      # System
      ../modules/shared/system/boot.nix
      ../modules/shared/system/common.nix
      ../modules/shared/system/common-gui.nix
      ../modules/shared/system/gc.nix
      ../modules/shared/system/overlays.nix
      ../modules/shared/system/performance.nix
      ../modules/shared/system/shell.nix
      ../modules/shared/system/user.nix
      ../modules/shared/system/zramswap.nix

      # Services
      ../modules/shared/services/autoupgrade.nix
      # UI
      ../modules/shared/ui/cosmic.nix
      #../modules/shared/ui/niri.nix
      ../modules/shared/ui/stylix-cosmic-theme-toggle.nix
    ];

}
