{ ... }:

{
  imports =
    [
      # System
      ../modules/shared/system/user.nix
      ../modules/shared/system/shell.nix
      ../modules/shared/system/common.nix
      ../modules/shared/system/gc.nix
      ../modules/shared/system/zramswap.nix

      # Services
      ../modules/shared/services/ssh.nix
      ../modules/shared/services/autoupgrade.nix
      ../modules/shared/services/qemu-guest-agent.nix
    ];

}
