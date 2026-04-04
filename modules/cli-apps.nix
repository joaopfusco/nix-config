{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # System utilities
    fastfetch

    # Nix tools
    home-manager
    nixfmt
    any-nix-shell

    # Python
    uv
    python312

    # Node
    nodejs_24

    # Go
    go_1_25
    gopls

    # Rust
    cargo
    rustc
    rustfmt
    clippy

    # Dev tools
    distrobox
    terraform
    azure-cli
  ];
}
