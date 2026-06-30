{ pkgs, ... }:
{
  # Performance tuning
  #boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;
  #services.bpftune.enable = true; # Enable the bpftune service
  #services.bpftune.package = pkgs.bpftune;  # Specify the bpftune package
  services.system76-scheduler.enable = true;
}
