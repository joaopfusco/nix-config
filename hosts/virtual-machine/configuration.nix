# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running 'nixos-help').

{ ... }:

{
  imports = [
    ../../modules/nixos/nix/config.nix
    ../../modules/nixos/nix/ld.nix
    ../../modules/nixos/networking.nix
    ../../modules/nixos/locale.nix
    ../../modules/nixos/user.nix

    ../../modules/nixos/boot/inotify.nix
    ../../modules/nixos/boot/grub.nix

    ../../modules/nixos/hardware/common.nix
    ../../modules/nixos/hardware/audio.nix

    ../../modules/nixos/desktop/gnome.nix
    ../../modules/nixos/pkgs/cli.nix
    ../../modules/nixos/pkgs/deps.nix
    ../../modules/nixos/pkgs/gui.nix
    ../../modules/nixos/pkgs/flatpak.nix

    ../../modules/nixos/virtualisation/docker.nix
    ../../modules/nixos/virtualisation/vm.nix
  ];

  system.stateVersion = "26.05";
}
