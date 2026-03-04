{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # Linguagens de Programação
    python312 # v3.12.12
    nodejs_24 # v24
    go_1_25 # v1.25.7

    # C e Make
    # gcc
    # gnumake

    # Rust
    # rustup

    # .NET SDKs e Runtimes
    # (with dotnetCorePackages; combinePackages [ 
    #   sdk_9_0
    #   runtime_9_0
    #   aspnetcore_9_0

    #   sdk_10_0
    #   runtime_10_0
    #   aspnetcore_10_0
    # ])
    # dotnet-ef

    # Ferramenta para criar ambientes rápidos
    # nix-init
    # nixpkgs-fmt
  ];
}