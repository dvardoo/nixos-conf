{ ... }:

{
  system.autoUpgrade = {
    enable = true;
    dates = "00:00";
    flake = "github:dvardoo/nixos-conf";
    allowReboot = false;
    randomizedDelaySec = "30min";
    flags = [ "--no-write-lock-file" ];
  };
}
