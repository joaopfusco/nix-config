{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # Linguagens de Programação
    python312 # v3.12.12
    nodejs_24 # v24
    go_1_25 # v1.25.7

    # Rust - Obs.: Melhor instlar via script do site oficial
    # rustup

    # .NET SDKs e Runtimes - Obs.: Melhor instalar nativamente
    # Obs.: Requires a global.json file in the project to specify the SDK version
    # dotnet new globaljson --sdk-version 8.0.xxx
    # dotnet tool install --global dotnet-ef
    # (with dotnetCorePackages; combinePackages [ 
    #   sdk_8_0
    #   sdk_9_0
    # ])

    # Ferramentas
    uv
  ];

  # Ou home.sessionPath ou ~/.profile
  # home.sessionPath = [
  #   "$HOME/.cargo/bin"
  #   "$HOME/.dotnet/tools"
  # ];
}