{
  flake.modules.nixos.flatpak = {
    # Only turns on the service/portal — apps installed imperatively (flatpak install).
    # Run: flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    services.flatpak.enable = true;
  };
}
