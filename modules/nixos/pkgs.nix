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
