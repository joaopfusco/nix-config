{
  pkgs,
  lib,
  config,
  ...
}:

{
  imports = [
    ./aliases.nix
    ./init.nix
  ];

  programs.zsh = {
    enable = true;
    package = lib.mkDefault pkgs.emptyDirectory;
    dotDir = "${config.xdg.configHome}/zsh";

    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "docker"
      ];
      theme = "robbyrussell";
    };
  };
}
