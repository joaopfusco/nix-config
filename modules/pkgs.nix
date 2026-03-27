{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # Nix tools
    home-manager
    nixfmt

    # Programming languages
    python312
    nodejs_24
    go_1_25

    # Rust
    cargo
    rustc
    rustfmt
    clippy

    # Dev tools
    uv
    terraform

    # Others
    fastfetch
  ];
}