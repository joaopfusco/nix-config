{
  flake.modules.homeManager.pkgs =
    { pkgs, ... }:
    {
      home.packages =
        (with pkgs; [
          # nix
          nixd
          devenv

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
