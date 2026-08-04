# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running 'nixos-help').

{ ... }:

{
  imports = [
    ../../modules/nix/config.nix
    ../../modules/nix/ld.nix
    ../../modules/networking.nix
    ../../modules/locale.nix
    ../../modules/user.nix

    ../../modules/boot/inotify.nix
    ../../modules/boot/grub.nix

    ../../modules/hardware/common.nix
    ../../modules/hardware/audio.nix

    ../../modules/desktop/gnome.nix
    ../../modules/pkgs/deps.nix
    ../../modules/pkgs/cli.nix
    ../../modules/pkgs/gui.nix
    ../../modules/pkgs/flatpak.nix

    ../../modules/virtualisation/docker.nix
    ../../modules/virtualisation/vm.nix
  ];

  system.stateVersion = "26.05";
}
