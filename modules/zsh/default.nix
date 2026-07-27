{ config, ... }:
{
  imports = [
    ./config/aliases.nix
    ./config/init-content.nix
    ./config/oh-my-zsh.nix
  ];

  programs.zsh = {
    enable = true;
    dotDir = "${config.xdg.configHome}/zsh";
  };
}
