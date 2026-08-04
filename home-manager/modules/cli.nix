{ pkgs, ... }:
{
  home.packages = with pkgs; [
    home-manager
    nixfmt
    nixd
    devenv
    fastfetch
    gnumake
    eza
    azure-cli
    codex
  ];
}
