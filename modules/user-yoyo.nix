{  pkgs, ... }:
{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.yoyo = {
    isNormalUser = true;
    description = "yoyo";
    extraGroups = [ "networkmanager" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
      keepassxc
      teams-for-linux
      zoom-us
      libreoffice
      nextcloud-client
      discord
    ];
  };
}
