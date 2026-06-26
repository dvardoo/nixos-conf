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
      ./qemu-guest-agent.nix
    ];

}
