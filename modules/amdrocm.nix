{ config, pkgs, inputs, ... }:
{
  # hashcat / games
  hardware.graphics.extraPackages = with pkgs; [
    rocmPackages.clr.icd
  ];
}
