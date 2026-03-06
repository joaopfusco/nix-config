{ pkgs, ... }: {
  services.flatpak = {
    enable = true;
    
    remotes = [{
      name = "flathub";
      location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
    }];

    packages = [
      "com.github.tchx84.Flatseal"
      "com.discordapp.Discord"
      "io.dbeaver.DBeaverCommunity"
      "org.libreoffice.LibreOffice"
      "com.obsproject.Studio"
      "us.zoom.Zoom"
      "page.codeberg.libre_menu_editor.LibreMenuEditor"
      "org.videolan.VLC"
      "com.ranfdev.DistroShelf"
      "org.virt_manager.virt-manager"
    ];

    update.auto.enable = true;
  };
}