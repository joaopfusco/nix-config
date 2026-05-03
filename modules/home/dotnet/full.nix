{ pkgs, ... }:

let
  dotnet-stack = (
    with pkgs.stable.dotnetCorePackages;
    combinePackages [
      sdk_8_0
      sdk_9_0
      sdk_10_0
    ]
  );
in
{
  imports = [
    ./base.nix
  ];

  home.packages = [
    dotnet-stack
    pkgs.stable.dotnet-ef
  ];

  home.sessionVariables = {
    DOTNET_ROOT = "${dotnet-stack}/share/dotnet";
    DOTNET_CLI_TELEMETRY_OPTOUT = "1";
    DOTNET_NOLOGO = "1";
  };
}
