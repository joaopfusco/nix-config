{
  flake.modules.nixos.gnome =
    { pkgs, ... }:
    {
      services.xserver.enable = true;

      services.displayManager.gdm.enable = true;
      services.desktopManager.gnome.enable = true;

      environment.sessionVariables.NIXOS_OZONE_WL = "1";
      environment.systemPackages = with pkgs; [
        gnome-tweaks
        gnome-extension-manager
        gnomeExtensions.clipboard-indicator
        gnomeExtensions.appindicator
        gnome-network-displays
        distroshelf
      ];
    };
}
