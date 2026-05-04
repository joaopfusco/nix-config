{ pkgs, lib, ... }:

{
  home.packages =
    with pkgs;
    [
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
      python3

      # Node
      nodejs

      # Go
      go
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
      devenv
    ]

    # Linux
    ++ lib.optionals stdenv.isLinux [
      gcc
      gdb
      nerd-fonts.jetbrains-mono
    ]

    # macOS (Darwin)
    ++ lib.optionals stdenv.isDarwin [

    ];
}
