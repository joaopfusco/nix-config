{
  pkgs,
  config,
  username,
  host,
  ...
}:

let
  zshPackage =
    if pkgs.stdenv.isLinux
    then pkgs.zsh
    else pkgs.emptyDirectory;
in
{
  programs.zsh = {
    enable = true;
    package = zshPackage;
    dotDir = "${config.xdg.configHome}/zsh";

    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      # Common aliases
      ll = "ls -l";
      la = "ls -la";
      cls = "clear";
      ins = "echo $IN_NIX_SHELL";
      py = "python3";

      # Home aliases
      home-switch = "home-manager switch --flake .#${username}@${host}";

      # Determinate Nix aliases
      dnix-upgrade = "sudo determinate-nixd upgrade";
      dnix-version = "determinate-nixd version";
    };

    initContent = ''
      autoload -U select-word-style
      select-word-style bash

      bindkey '^H' backward-kill-word
      bindkey '^[[3;5~' kill-word

      bindkey "^[[1;5C" forward-word
      bindkey "^[[1;5D" backward-word
    '';

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "z"
        "docker"
      ];
      theme = "gentoo";
    };
  };
}
