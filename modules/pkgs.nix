{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # Nix tools
    home-manager
    nixfmt

    # Python
    uv
    python312

    # Node
    nodejs_24

    # Go
    go_1_25

    # Rust
    cargo
    rustc
    rustfmt
    clippy

    # Dev tools
    terraform
    azure-cli

    # Others
    fastfetch
  ];
}