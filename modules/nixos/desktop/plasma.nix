{ pkgs, ... }:
{
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Enable the Ozone/Wayland backend for better performance and compatibility with modern hardware.
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # KDE Plasma Apps
  environment.systemPackages = with pkgs; [
    kontainer
  ];
}
