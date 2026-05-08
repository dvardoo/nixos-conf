{ ... }:
{
  # Enable Cinnamon DE
  services.xserver.desktopManager.cinnamon.enable = true;
  services.xserver.displayManager.lightdm.enable = true;

  services.gnome.gnome-online-accounts.enable = true;

  #environment.sessionVariables = {
  #  MOZ_USE_XINPUT2=1; # Fix Firefox-based browsers scroll on X11.
  #};
}
