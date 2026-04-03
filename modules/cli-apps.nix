{ config, pkgs, ... }:

{
  import = [
    # Generic modules
    ./git.nix
    ./zsh.nix
    ./direnv.nix
  ];

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
    terraform
    azure-cli
  ];
}
