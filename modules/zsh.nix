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
      vm-status = "systemctl status libvirtd";
      vm-start = "sudo systemctl start libvirtd";
      vm-stop = "sudo systemctl stop 'libvirtd*'";
    };

    initContent = ''
      autoload -U select-word-style
      select-word-style bash
    '';
  };
}
