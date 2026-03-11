{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # Linguagens de Programação
    python312 # v3.12.12
    nodejs_24 # v24
    go_1_25 # v1.25.7

    # Rust
    # rustup

    # .NET SDKs e Runtimes
    # Obs.: Requires a global.json file in the project to specify the SDK version
    # dotnet new globaljson --sdk-version 8.0.xxx
    (with dotnetCorePackages; combinePackages [ 
      sdk_8_0
      sdk_9_0
    ])
    dotnet-ef

    # Ferramentas
    uv
    # nix-init
    # nixpkgs-fmt
  ];

  home.sessionPath = [
    "/home/joaop/.dotnet/tools"
  ];
}