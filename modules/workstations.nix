{ ... }:
{
  # Unlock disk GUI, also quiet systemd startup messages
  #boot = {
  # silence first boot output
  #  consoleLogLevel = 3;
  #  initrd.verbose = false;
  #  initrd.systemd.enable = true;
  #  kernelParams = [
  #      "quiet"
  #      "splash"
  #      "intremap=on"
  #      "boot.shell_on_fail"
  #      "udev.log_priority=3"
  #      "rd.systemd.show_status=auto"
  # ];

    # plymouth, showing after LUKS unlock
  #  plymouth.enable = true;
  #  plymouth.font = "${pkgs.hack-font}/share/fonts/truetype/Hack-Regular.ttf";
  #  plymouth.logo = "${pkgs.nixos-icons}/share/icons/hicolor/128x128/apps/nix-snowflake.png";
  #};

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Install firefox.
  programs.firefox.enable = true;
  programs.kdeconnect.enable = true;

}
