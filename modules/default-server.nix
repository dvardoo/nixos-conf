{ ... }:

{
  imports =
    [
      ./user.nix
      ./shell.nix
      ./common.nix
      ./ssh.nix
      ./gc.nix
      ./autoupgrade.nix
      ./zramswap.nix
      ./qemu-guest-agent.nix
    ];

}
