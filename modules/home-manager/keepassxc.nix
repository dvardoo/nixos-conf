{ pkgs, ... }:

{
  programs.keepassxc = {
    enable = true;
    settings = {
      Browser = {
        Enabled = false;
        SearchInAllDatabases = true;
      };

      #FdoSecrets.Enabled = true;
      #SSHAgent.Enabled = true;

      Security = {
        ClearClipboardTimeout = 30;
        EnableCopyOnDoubleClick = true;
        IconDownloadFallback = true;
        LockDatabaseIdle = true;
        LockDatabaseIdleSeconds = 600;
      };
    };

  };

  #programs.firefox.nativeMessagingHosts = [ pkgs.keepassxc ];
}
