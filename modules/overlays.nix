{ config, pkgs, inputs, ... }:
{
  # Until this is resolved: https://github.com/nixos/nixpkgs/issues/513245
  nixpkgs.overlays = [
    (_: prev: {
      openldap = prev.openldap.overrideAttrs {
        doCheck = !prev.stdenv.hostPlatform.isi686;
      };
    })
  ];

}
