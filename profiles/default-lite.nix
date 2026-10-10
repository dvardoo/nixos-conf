{ ... }:

{
  imports =
    [
      # System
      ../modules/shared/system/user.nix
      ../modules/shared/system/shell.nix
      ../modules/shared/system/common.nix
      ../modules/shared/system/boot.nix
      ../modules/shared/system/gc.nix
      ../modules/shared/system/zramswap.nix
      #../modules/shared/system/performance.nix
      #../modules/shared/system/overlays.nix

      # Services
      ../modules/shared/services/ssh.nix
      ../modules/shared/services/autoupgrade.nix

      # UI
      ../modules/shared/ui/cinnamon.nix
      ../modules/shared/ui/common-gui.nix
    ];

}
