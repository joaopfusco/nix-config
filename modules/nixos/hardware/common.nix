{
  flake.modules.nixos.hardwareCommon = {
    hardware.enableAllFirmware = true;
    hardware.enableRedistributableFirmware = true;
    hardware.bluetooth.enable = true;
    hardware.bluetooth.powerOnBoot = true;
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
    services.fwupd.enable = true;
    services.libinput.enable = true;
    services.libinput.touchpad.tapping = true;
    services.libinput.touchpad.naturalScrolling = true;
    services.printing.enable = true;
  };
}
