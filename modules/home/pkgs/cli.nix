{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    # System utilities
    fastfetch

    # Nix tools
    home-manager
    nixfmt
    alejandra
    nixd
    nil
    statix

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
    btop
    fd
    fzf
    ripgrep
    lazygit
    gnumake
    terraform
    azure-cli
    claude-code
  ]

  # Linux
  ++ lib.optionals stdenv.isLinux [
    gcc
    gdb
  ]

  # macOS (Darwin)
  ++ lib.optionals stdenv.isDarwin [

  ];
}
