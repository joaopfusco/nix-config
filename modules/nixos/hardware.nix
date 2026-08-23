{
  flake.modules.nixos.hardware = {
    # hardware
    hardware.enableAllFirmware = true;
    hardware.enableRedistributableFirmware = true;
    hardware.bluetooth.enable = true;
    hardware.bluetooth.powerOnBoot = false;
    hardware.graphics.enable = true;
    hardware.graphics.enable32Bit = true;
    # services
    services.fwupd.enable = true;
    services.libinput.enable = true;
    services.libinput.touchpad.tapping = true;
    services.libinput.touchpad.naturalScrolling = true;
    services.printing.enable = true;
  };
}
