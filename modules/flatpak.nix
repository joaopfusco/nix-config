{ pkgs, ... }: {
  services.flatpak = {
    enable = true;
    
    remotes = [{
      name = "flathub";
      location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
    }];

    packages = [
      "com.discordapp.Discord"
      "io.dbeaver.DBeaverCommunity"
      "org.libreoffice.LibreOffice"
      "com.obsproject.Studio"
      "us.zoom.Zoom"
      "org.gnome.alacarte" 
      "org.videolan.VLC"
    ];

    update.auto.enable = true;
  };
}