{ config, pkgs, ... }:

{
  # mise install
  # dotnet tool install --global dotnet-ef

  programs.mise = {
    enable = true;
    enableZshIntegration = true;
  };

  home.sessionPath = [
    "$HOME/.local/share/mise/shims"
    "$HOME/.dotnet/tools"
  ];
}