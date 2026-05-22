# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ username, ... }:

{
  imports = [
    ../../modules/nixos/system/minimal.nix
    ../../modules/nixos/pkgs/minimal.nix
    ../../modules/nixos/user.nix
    ../../modules/nixos/ld.nix
  ];

  wsl = {
    enable = true;
    defaultUser = username;
  };

  system.stateVersion = "25.11";
}
