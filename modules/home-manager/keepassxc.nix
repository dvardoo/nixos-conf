# Work in progress, autotype window appears but nothing types
# Missing icon and tray icon. KeeShare will not work
# All settings must be defined in the file, no changes in GUI will work
# If home-manager complains:
# rm -f ~/.config/keepassxc
# Then rebuild
{ pkgs, lib, ... }:

let
  # A tiny wrapper for auto-type to work that forces keepassxc to run as: keepassxc -platform xcb
  keepassxcWrapper = pkgs.writeShellScriptBin "keepassxc" ''
    exec ${pkgs.keepassxc}/bin/keepassxc -platform xcb "$@"
  '';
in

{
  # Dotfile settings
  home.file.".config/keepassxc/keepassxc.ini" = {
    force = true;  # Force file creation
    text = ''
      [General]
      BackupBeforeSave=true
      ConfigVersion=2
      GlobalAutoTypeEnabled=true
      GlobalAutoTypeKey=90
      GlobalAutoTypeModifiers=201326592

      [Browser]
      CustomProxyLocation=

      [GUI]
      ApplicationTheme=dark
      CompactMode=true
      MinimizeToTray=true
      ShowTrayIcon=true
      TrayIconAppearance=colorful

      [PasswordGenerator]
      AdditionalChars=
      ExcludedChars=

      [Security]
      IconDownloadFallback=true
    '';
  };

  # Additional activation to ensure correct file handling
  home.activation.fixKeePassXCConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
    CONFIG_PATH="$HOME/.config/keepassxc/keepassxc.ini"
    
    # Ensure the file exists and has correct permissions
    if [ -f "$CONFIG_PATH" ]; then
      chmod 600 "$CONFIG_PATH"
    fi
  '';

  programs.keepassxc = {
    enable = true;
    package = keepassxcWrapper;
  };

  home.packages = [ 
    keepassxcWrapper 
  ];

  # A desktop entry for the wrapper
  xdg.desktopEntries.keepassxc = {
    name = "KeePassXC";
    exec = "keepassxc %F";
    #icon = "keepassxc";
    icon = "/run/current-system/sw/share/icons/hicolor/scalable/apps/nix-snowflake-white.svg";
    type = "Application";
    categories = [ "Utility" "Security" ];
    mimeType = [ "application/x-keepass2" ];
  };

}
