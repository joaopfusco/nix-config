{ pkgs, ... }:

{
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # Enable the Ozone/Wayland backend for better performance and compatibility with modern hardware.
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # GNOME Apps
  environment.systemPackages = with pkgs; [
    gnome-tweaks
    gnome-extension-manager
    gnomeExtensions.clipboard-indicator
    gnomeExtensions.appindicator
    gnome-network-displays
    distroshelf
  ];
}
