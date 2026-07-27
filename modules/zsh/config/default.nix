{ config, ... }:
{
  imports = [
    ./aliases.nix
    ./init-content.nix
    ./oh-my-zsh.nix
  ];

  programs.zsh = {
    enable = true;
    package = config.lib.own.mkConfigOnly "zsh";
    dotDir = "${config.xdg.configHome}/zsh";

    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
  };
}
