{
  flake.modules.nixos.pkgs =
    { pkgs, ... }:
    {
      # Packages
      environment.systemPackages = with pkgs; [
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
