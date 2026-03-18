{ config, pkgs, username, ... }:

{
  # nao executar no host, apenas em distobox
  # echo "$(which zsh)" | sudo tee -a /etc/shells
  # chsh -s $(which zsh)

  programs.zsh = {
    enable = true;
    dotDir = "${config.xdg.configHome}/zsh";

    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    
    shellAliases = {
      ll = "ls -l";
      la = "ls -la";
      cls = "clear";
      home-switch = "home-manager switch --flake .#${username}";
    };

    initContent = ''
      # 1. Faz o Ctrl+Backspace (e outros) parar em barras, pontos, etc.
      autoload -U select-word-style
      select-word-style bash

      # 2. Mapeia o Ctrl+Backspace corretamente
      bindkey '^H' backward-kill-word
      bindkey '^[[3;5~' kill-word # Ctrl+Delete apaga a palavra à frente

      # 3. Mapeia Ctrl+Setas para pular palavras
      bindkey "^[[1;5C" forward-word
      bindkey "^[[1;5D" backward-word
    '';
  };
}
