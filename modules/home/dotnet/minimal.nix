{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    netcoredbg
  ];

  home.sessionPath = [
    "${config.home.homeDirectory}/.dotnet/tools"
  ];
}
