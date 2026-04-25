{ config, pkgs, ... }:

{
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.displayManager.gdm.enable = true;
  services.displayManager.gdm.wayland = true;
  services.desktopManager.gnome.enable = true;

  # Enable the Ozone/Wayland backend for better performance and compatibility with modern hardware.
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # GNOME Tweaks and Extensions for customization
  environment.systemPackages = with pkgs; [
    gnome-tweaks
    gnome-extension-manager
    gnomeExtensions.clipboard-indicator
    gnomeExtensions.appindicator
  ];

  # Reset GNOME settings to default values
  /*
  gsettings reset org.gnome.desktop.interface icon-theme
  gsettings reset org.gnome.desktop.interface gtk-theme
  gsettings reset org.gnome.desktop.interface font-name
  gsettings reset org.gnome.desktop.interface monospace-font-name
  gsettings reset org.gnome.desktop.interface cursor-theme
  */
}
