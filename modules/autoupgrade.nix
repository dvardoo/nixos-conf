{ pkgs, ... }:

{
  system.autoUpgrade = {
    enable = true;
    dates = "03:00";
    flake = "github:dvardoo/nixos-conf";
    allowReboot = false;
    randomizedDelaySec = "30min";
    flags = [
      "--no-write-lock-file"
      "--max-jobs" "2"
      "--cores" "2"
    ];
    persistent = true;
  };

  systemd.services.nixos-upgrade = {
      serviceConfig = {
        CPUSchedulingPolicy = "idle";
        IOSchedulingClass = "idle";
      };

      preStart = ''
        TIMESTAMP=$(${pkgs.coreutils}/bin/date '+%Y-%m-%d %H:%M:%S')
        ${pkgs.libnotify}/bin/notify-send "NixOS Upgrade" "Auto-upgrade starting at $TIMESTAMP" 2>/dev/null || true
        ${pkgs.util-linux}/bin/wall "Auto-upgrade starting at $TIMESTAMP" 2>/dev/null || true
      '';

      postStart = ''
        TIMESTAMP=$(${pkgs.coreutils}/bin/date '+%Y-%m-%d %H:%M:%S')
        REBOOT_STATUS=$(if diff <(${pkgs.coreutils}/bin/readlink /run/booted-system/{initrd,kernel,kernel-modules}) <(${pkgs.coreutils}/bin/readlink /nix/var/nix/profiles/system/{initrd,kernel,kernel-modules}); then echo "✓ No reboot needed"; else echo "↻ Reboot needed"; fi)

        ${pkgs.libnotify}/bin/notify-send "NixOS Upgrade" "Completed at $TIMESTAMP\n$REBOOT_STATUS" 2>/dev/null || true
        ${pkgs.util-linux}/bin/wall "Auto-upgrade completed at $TIMESTAMP - $REBOOT_STATUS" 2>/dev/null || true
      '';
    };
}
