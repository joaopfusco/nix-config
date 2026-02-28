{ config, pkgs, ... }:

{
  # # nao executar no host, apenas em distobox
  # echo "$(which zsh)" | sudo tee -a /etc/shells
  # chsh -s $(which zsh)

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ll = "ls -l";
      la = "ls -la";
      cls = "clear";
      home-update = "home-manager switch --flake .#joaop";
    };

    initContent = ''
      host() {
        distrobox-host-exec "$@"         
      }
    '';

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "z" ];
      theme = "robbyrussell";
    };
  };
}
