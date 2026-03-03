{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # Compiladores e Runtimes
    gcc
    gnumake
    python3
    nodejs
    go
    rustup

    # .NET SDKs e Runtimes
    (with dotnetCorePackages; combinePackages [ 
      sdk_9_0
      runtime_9_0
      aspnetcore_9_0

      sdk_10_0
      runtime_10_0
      aspnetcore_10_0
    ])
    dotnet-ef

    # Ferramenta para criar ambientes rápidos
    nix-init
    nixpkgs-fmt
  ];
}