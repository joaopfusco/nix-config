{ config, lib, pkgs, ... }:

{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = false;

      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[✗](bold red)";
      };

      directory = {
        truncation_length = 3;
        truncate_to_repo = true;
        style = "bold blue";
      };

      git_branch = {
        symbol = "🌱 ";
        truncation_length = 15;
      };

      git_status = {
        conflicted = "🏳";
        ahead = "🚗💨";
        behind = "😰";
        staged = "[++\\($count\\)](green)";
      };

      nix_shell = {
        symbol = "❄️ ";
        format = "via [$symbol $state( \\($name\\))]($style) ";
      };
      
      cmd_duration = {
        min_time = 2000; # Mostra apenas se o comando levar mais de 2 segundos
        format = "took [$duration]($style) ";
      };

      nodejs.symbol = "🟢 ";
    };
  };
}