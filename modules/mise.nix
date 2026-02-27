{ config, pkgs, ... }:

{
  # echo 'export PATH="/home/joaop/.local/share/mise/shims:$PATH"' >> ~/.profile
  # dotnet tool install --global dotnet-ef

  programs.mise = {
    enable = true;
    enableZshIntegration = true;
  };

  home.sessionPath = [
    # "${config.home.homeDirectory}/.local/share/mise/shims"
    # "${config.home.homeDirectory}/.dotnet/tools"
  ];
}