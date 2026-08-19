{
  flake.modules.nixos.apps =
    { pkgs, ... }:
    {
      environment.systemPackages =
        (with pkgs; [
          # media codecs
          gst_all_1.gstreamer
          gst_all_1.gst-plugins-base
          gst_all_1.gst-plugins-good
          gst_all_1.gst-plugins-bad
          gst_all_1.gst-plugins-ugly
          gst_all_1.gst-libav

          # apps
          libreoffice
          vlc
          obs-studio
          vscode
          dbeaver-bin
          postman
        ])
        ++ (with pkgs.unstable; [
          google-chrome
        ]);

      programs.firefox = {
        enable = true;
        package = pkgs.unstable.firefox;
      };

      # Only turns on the service/portal — apps installed imperatively (flatpak install).
      # Run: flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
      services.flatpak.enable = true;
      xdg.portal.enable = true;
    };
}
