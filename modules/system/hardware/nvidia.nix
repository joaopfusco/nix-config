{ config, pkgs, ... }:

{
  # NVIDIA GPU drivers
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    # Modesetting is critical for Wayland support
    modesetting.enable = true;

    # Enable power management features for NVIDIA GPUs, including fine-grained power management.
    powerManagement.enable = true;

    # Enable the NVIDIA settings menu (nvidia-settings)
    nvidiaSettings = true;

    # Using the proprietary NVIDIA driver
    open = false;

    # Select the driver package version
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
}
