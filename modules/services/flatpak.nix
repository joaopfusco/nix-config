{
  flake.modules.nixos.flatpak = {
    # Só liga o serviço/portal — apps instalados imperativamente (flatpak install).
    # Rodar: flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    services.flatpak.enable = true;
  };
}
