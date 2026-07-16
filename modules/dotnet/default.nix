{ pkgs, ... }:

let
  dotnet-stack = (
    with pkgs.dotnetCorePackages;
    combinePackages [
      sdk_8_0
      sdk_9_0
      sdk_10_0
    ]
  );
in
{
  imports = [
    ./config
  ];

  home.packages = [
    dotnet-stack
    pkgs.dotnet-ef # dotnet tool install --global dotnet-ef
    pkgs.csharp-ls # dotnet tool install --global csharp-ls
  ];

  home.sessionVariables = {
    # UseAppHost = "false";
    DOTNET_ROOT = "${dotnet-stack}/share/dotnet";
  };
}
