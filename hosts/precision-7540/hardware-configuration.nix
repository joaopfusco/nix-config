# PLACEHOLDER — this machine still runs Ubuntu. Regenerate this file for
# real with `nixos-generate-config` at install time (it needs the actual
# partition UUIDs, which don't exist until NixOS is actually installed).
{ lib, ... }:

{
  # Fake root fs, just so `system.build.toplevel` evaluates before the real install.
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/00000000-0000-0000-0000-000000000000";
    fsType = "ext4";
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
