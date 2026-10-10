{ pkgs, ... }:
{
  # For hashcat / LLM
  hardware.graphics.extraPackages = with pkgs; [
    rocmPackages.clr.icd
  ];

}
