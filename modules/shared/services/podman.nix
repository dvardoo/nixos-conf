# shared/services/podman.nix
{ pkgs, lib, ... }:
{
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;   # docker command alias for podman
    defaultNetwork.settings.dns_enabled = true;
  };

  environment.systemPackages = [ pkgs.podman-compose ];

  users.users.containers = {
    isNormalUser = true;
    uid = 1500;   # fixed so NFS ownership matches on the NAS
    description = "Rootless container runner";
    home = "/home/containers";
    linger = true;
    openssh.authorizedKeys.keys = [
      #"ssh-ed25519 placeholder for container user"
    ];
  };

  # Start rootless containers that have a restart policy when the user manager starts
  systemd.user.services.podman-restart = {
    description = "Start rootless containers with a restart policy";
    wantedBy = [ "default.target" ];
    after = [ "podman.socket" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = [
        "${pkgs.podman}/bin/podman start --all --filter restart-policy=always"
        "${pkgs.podman}/bin/podman start --all --filter restart-policy=unless-stopped"
      ];
    };
  };

  boot.kernel.sysctl."net.ipv4.ip_unprivileged_port_start" = lib.mkDefault 1024;

  # --- Privileged ports for rootless containers ---
  # Rootless containers can only bind ports at or above this value.
  # The default of 1024 is kept here. To allow a lower port on one host,
  # override it in that host's configuration.nix, for example:
  #   boot.kernel.sysctl."net.ipv4.ip_unprivileged_port_start" = 80;
}
