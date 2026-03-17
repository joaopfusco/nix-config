{ config, pkgs, lib, ... }:

{
  imports = [
    ../services/myflatpak.nix
  ];

  services.myflatpak = {
    enable = true;
    uninstallUnmanaged = true;

    remotes = [{
      name = "flathub";
      location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
    }];

    packages = [
      "com.github.tchx84.Flatseal"
      "org.videolan.VLC"
      "com.discordapp.Discord"
      "io.dbeaver.DBeaverCommunity"
      "org.libreoffice.LibreOffice"
      "com.obsproject.Studio"
      "page.codeberg.libre_menu_editor.LibreMenuEditor"
      "com.ranfdev.DistroShelf"
      "us.zoom.Zoom"
      "com.brave.Browser"
    ];

    update.auto.enable = true;
  };
}