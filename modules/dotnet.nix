{ pkgs, config, ... }:

{
  home.packages = with pkgs; [
    # tools
    dotnet-ef # dotnet tool install --global dotnet-ef
  ];
  
  home.sessionPath = [
    "${config.home.homeDirectory}/.dotnet/tools"
  ];

  home.sessionVariables = {
    DOTNET_CLI_TELEMETRY_OPTOUT = "1";
    DOTNET_NOLOGO = "1";
  };
}
