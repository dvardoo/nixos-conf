services.openssh.enable = true;

services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
    };
    authorizedKeys.users = {
      dvardo = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF9egc+MNLkaP9pnz0G0kUt2Bb5HOeJTgAuUXOzK0T1e workstation"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKsqdLfJFkI3rTRpG0y4r80j3fAV+VVgkZJgqu0v3dra nix-thinkpad"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDSyxN4GOtbvU++XRFRe2XtcksFUIE3OEPWg6ptEF7+n pixel"
      ];
    };
  };
