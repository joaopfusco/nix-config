{ config, pkgs, ... }:

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
    
    initContent = ''
      [ -f ~/.aliases.nix ] && source ~/.aliases.nix
    '';

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "z" ];
    };
  };
}
