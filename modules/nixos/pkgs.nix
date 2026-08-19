{
  flake.modules.nixos.pkgs =
    { pkgs, ... }:
    {
      # Packages
      environment.systemPackages = with pkgs; [
        # media codecs
        gst_all_1.gstreamer
        gst_all_1.gst-plugins-base
        gst_all_1.gst-plugins-good
        gst_all_1.gst-plugins-bad
        gst_all_1.gst-plugins-ugly
        gst_all_1.gst-libav

        # packages
        wget
        curl
        btop
        distrobox
      ];

      # Docker
      virtualisation.docker.enable = true;

      # Flatpak
      # Only turns on the service/portal — apps installed imperatively (flatpak install).
      # Run: flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
      services.flatpak.enable = true;

      # Nix LD
      programs.nix-ld = {
        enable = true;
        libraries = with pkgs; [
          stdenv.cc.cc
          zlib
          openssl
          libGL
          glib
        ];
      };
    };
}
