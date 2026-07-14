# PLACEHOLDER — this machine still runs Ubuntu. Regenerate this file for
# real with `nixos-generate-config` at install time (it needs the actual
# partition UUIDs, which don't exist until NixOS is actually installed).
{ lib, ... }:

{
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
