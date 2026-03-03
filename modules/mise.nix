{ config, pkgs, ... }:

{
  programs.mise = {
    enable = true;
    enableZshIntegration = true;
    globalConfig = {
      tools = {
        python = "latest";
        node = "lts";
        dotnet = "latest";
        go = "latest";
        rust = "latest";
      };
      settings = {
        experimental = true;
      };
    };
  };

  home.sessionPath = [
    "${config.home.homeDirectory}/.local/share/mise/shims"
    "${config.home.homeDirectory}/.dotnet/tools" # dotnet tool install --global dotnet-ef
  ];
}