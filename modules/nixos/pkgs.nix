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
      programs.nix-ld.enable = true;
      programs.nix-ld.libraries = with pkgs; [
        libGL
        icu
        libunwind
        libuuid
        krb5
        glib
        lttng-ust
      ];
    };
}
