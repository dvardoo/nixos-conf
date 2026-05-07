{ ... }:

{
  imports =
    [
      ./user.nix
      ./shell.nix
      ./common.nix
      ./ssh.nix
      ./gc.nix
      ./qemu-guest-agent.nix
    ];

}
