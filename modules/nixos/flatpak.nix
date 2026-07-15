{ ... }:
{
  # Just enables the service/portal — apps themselves are installed
  # imperatively (flatpak install), not declared here.
  # Run flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
  services.flatpak.enable = true;
}
