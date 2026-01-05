# Intro

## Getting started

### New host
1. Install a new machine
2. Install git on the new machine in `nix-shell -p git`
3. In the repo, create a directory for the new host under `hosts/` with a basic `configurations.nix` (copy an existing one) and remember to copy the existing bootloader options from the new machine here.
4. Copy the existing `hardware-configurations.nix` from the new machine to the repo under `hosts/newhostname/`
5. In the repo, add the host in the `flake.nix` (just copy the part from other host and change hostname)
6. Generate SSH keys and add the public key to `ssh.nix` if needed for public key authentication
7. Commit and push changes
8. On the new machine, clone the repo with `git clone https://github.com/dvardoo/nixos-conf` and from that directory run:
```bash
sudo nixos-rebuild switch --flake .#$newhostname
```


## To do

- [x] Refactor config from configuration.nix
- [x] Add another host
- [x] Add jovian-NixOS
- [ ] Add a server host with some services
- [ ] Migrate services from old hosts
- [ ] Add a managed, easy host for friends/family
- [ ] Fix autoupgrade 
- [x] Fix auto collect garbage
- [ ] Explore home-manager
- [ ] Configure Cosmic DE
- [ ] Secrets management
