{ pkgs, ... }: 

{
  stylix = {
    enable = true;
    targets.librewolf = {
      enable = true;
      profileNames = [ "default" ];
    };

    # Ensure Gruvbox theme is explicitly set
    #base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";
  };

  programs.librewolf = {
    enable = true;
    
    settings = {
      # Tab Restoration Configuration
      "browser.startup.page" = 3; # 3 means "Restore previous session"
      "browser.startup.homepage" = "https://your-custom-homepage.com";
      
      # New Tab Page Configuration
      "browser.newtabpage.enabled" = true;
      "browser.newtabpage.url" = "https://your-custom-new-tab-page.com";

      # Privacy and Security Enhancements
      "privacy.trackingprotection.enabled" = true;
      "privacy.clearOnShutdown.cache" = true;
      "privacy.clearOnShutdown.cookies" = true;
      
      # Session Restore Specific Settings
      "browser.sessionstore.resume_from_crash" = true;
      "browser.sessionstore.max_tabs_undo" = 20; # Number of tabs you can restore
      
      # Prompt for session restoration
      "browser.startup.shouldRestoreSession" = true;
      "browser.sessionstore.restore_on_demand" = true; # Allow manual tab restoration
      
      # Additional Useful Configurations
      "browser.tabs.closeWindowWithLastTab" = false; # Keep window open when last tab is closed
      "browser.tabs.insertAfterCurrent" = true; # New tabs open next to current tab
      
      # Performance and Memory
      "browser.cache.disk.enable" = true;
      "browser.cache.memory.enable" = true;
      
      # Telemetry and Data Collection Opt-out
      "toolkit.telemetry.enabled" = false;
      "datareporting.healthreport.uploadEnabled" = false;

      # Don't burn my eyes please
      "ui.systemUsesDarkTheme" = 1;
      "browser.theme.dark-private-windows" = true;
    };
  };
}
