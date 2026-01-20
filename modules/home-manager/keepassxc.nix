{ pkgs, ... }:

{
  programs.keepassxc = {
    enable = true;
    settings = {
      GUI = {
        ApplicationTheme = "dark";
        ShowTrayIcon = true;
        TrayIconAppearance = "monochrome-light";
        MinimizeToTray = true;
      };

      Browser = {
        Enabled = false;
        SearchInAllDatabases = false;
      };

      #FdoSecrets.Enabled = true;
      #SSHAgent.Enabled = true;

      Security = {
        LockDatabaseOnClose = true;
        LockDatabaseOnExit = true;
        LockDatabaseOnScreenLock = true;
        ClearClipboardTimeout = 30;
        EnableCopyOnDoubleClick = true;
        IconDownloadFallback = true;
        LockDatabaseIdle = true;
        LockDatabaseIdleSeconds = 600;
        #BackupBeforeSaving = true;
        #BackupFileExtension = ".old.kdbx"; 
      };
    };

  };

  #programs.firefox.nativeMessagingHosts = [ pkgs.keepassxc ];
}
