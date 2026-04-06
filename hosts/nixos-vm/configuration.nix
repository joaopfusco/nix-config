# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, inputs, ... }:

{
  imports = [
    # NixOS Hardware
    # inputs.nixos-hardware.nixosModules.common-pc-laptop
    # inputs.nixos-hardware.nixosModules.common-pc-laptop-ssd
    # inputs.nixos-hardware.nixosModules.common-cpu-intel
    
    # Modules
    # ../../modules/system/hardware/nvidia.nix
    ../../modules/system/system.nix
    ../../modules/system/gnome.nix
    ../../modules/system/user.nix
    ../../modules/system/pkgs.nix
  ];

  # Bootloader
  boot.loader.grub.enable = true;
  boot.loader.grub.devices = [ "/dev/vda" ];
  boot.loader.grub.useOSProber = true;

  system.stateVersion = "25.11";
}
