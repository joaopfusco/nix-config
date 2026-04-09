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

    # C#
    # (with dotnetCorePackages; combinePackages [
    #   sdk_8_0
    #   sdk_9_0
    # ])

    # Dev tools
    gnumake
    terraform
    azure-cli
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

  home.sessionPath = [
    "${config.home.homeDirectory}/.dotnet/tools"
  ];
}
