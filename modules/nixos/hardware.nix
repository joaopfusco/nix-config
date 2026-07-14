{ ... }:
{
  # Enable fwupd to keep firmware up to date
  services.fwupd.enable = true;

  # Enable all firmware to support a wide range of hardware.
  hardware.enableAllFirmware = true;
  hardware.enableRedistributableFirmware = true;

  # Enable input devices
  services.libinput.enable = true;
  services.libinput.touchpad.tapping = true;
  services.libinput.touchpad.naturalScrolling = true;

  # Enable Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # Enable graphics and hardware acceleration
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
}
