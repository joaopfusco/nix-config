{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    # System utilities
    fastfetch

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
    gopls

    # Rust
    cargo
    rustc
    rustfmt
    clippy

    # Others
    gnumake
    terraform
    azure-cli
    ripgrep
  ]

  # Linux
  ++ lib.optionals stdenv.isLinux [
    gcc
    gdb
    distrobox
  ]
  
  # macOS (Darwin)
  ++ lib.optionals stdenv.isDarwin [
    
  ];
}
