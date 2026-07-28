{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # nix
    home-manager
    nixfmt
    nixd
    devenv
    # tools
    fastfetch
    gnumake
    eza
    azure-cli
    codex
  ];
}
