{ ... }:

{
  imports = [
    ./base.nix
  ];

  # Enable networking
  networking.networkmanager.enable = true;
  networking.firewall.enable = true;

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

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "intl";
  };

  # Configure console keymap
  console.keyMap = "us-acentos";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
}
