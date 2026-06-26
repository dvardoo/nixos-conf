{ ... }:

{
  system.autoUpgrade = {
    enable = true;
    dates = "23:30";
    flake = "github:dvardoo/nixos-conf";
    allowReboot = false;
    randomizedDelaySec = "30min";
  };
}
