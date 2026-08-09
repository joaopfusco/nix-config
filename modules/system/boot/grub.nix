{
  flake.modules.nixos.grub = {
    boot.loader.grub.enable = true;
    boot.loader.grub.devices = [ "/dev/vda" ];
    boot.loader.grub.useOSProber = true;
  };
}
