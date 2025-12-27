{ config, pkgs, inputs, ... }:
{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.dvardo = {
    isNormalUser = true;
    description = "dvardo";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    #  thunderbird
    ];
    authorizedKeys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF9egc+MNLkaP9pnz0G0kUt2Bb5HOeJTgAuUXOzK0T1e workstation"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKsqdLfJFkI3rTRpG0y4r80j3fAV+VVgkZJgqu0v3dra nix-thinkpad"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDSyxN4GOtbvU++XRFRe2XtcksFUIE3OEPWg6ptEF7+n pixel"
      ];
  };
}
