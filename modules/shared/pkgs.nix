{
  flake.modules.nixos.pkgs =
    { pkgs, ... }:
    {
      # Packages
      environment.systemPackages = with pkgs; [
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

  flake.modules.homeManager.pkgs =
    { pkgs, ... }:
    {
      home.packages =
        (with pkgs; [
          # nix
          nixd
          devenv
          nix-output-monitor
          nvd

          # tools
          wget
          curl
          nano
          bat
          eza
          jq
          ripgrep
          fd
          glab

          # packages
          pfetch
          fastfetch
          gnumake
          azure-cli
        ])
        ++ (with pkgs.unstable; [
          # packages
          codex
        ]);
    };
}
