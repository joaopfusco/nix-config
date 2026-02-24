{ config, pkgs, ... }:

{
  # mise install
  # dotnet tool install --global dotnet-ef

  programs.mise = {
    enable = true;
    enableZshIntegration = true;
    
    globalConfig = {
      settings = {
        experimental = true;
        always_keep_download = false;
        plugin_autoupdate_last_check_duration = "1 week";
      };
      
      tools = {
        node = "lts";
        python = "3.12";
        go = "1.25.6";
        dotnet = "latest";
        rust = "stable";
      };
    };
  };

  home.sessionPath = [
    "$HOME/.dotnet/tools"
  ];
}