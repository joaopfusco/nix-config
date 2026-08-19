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
          nano
          bat
          eza
          jq
          ripgrep
          fd

          # packages
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
