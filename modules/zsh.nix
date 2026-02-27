{ config, pkgs, ... }:

{
  # .bashrc
  # alias zsh="exec zsh -l"
  # alias bash="exec bash -l"
  # if [[ $- == *i* ]]; then
  #     ZSH_BIN=$(which zsh 2>/dev/null)
  #     if [[ -n "$ZSH_BIN" && $(ps -p $PPID -o comm=) != *"zsh"* ]]; then
  #         export SHELL="$ZSH_BIN"
  #         exec "$ZSH_BIN" -l
  #     fi
  # fi

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
      vm-status = "systemctl status libvirtd";
      vm-start = "sudo systemctl start libvirtd";
      vm-stop = "sudo systemctl stop 'libvirtd*'";
    };

    initContent = ''
    '';

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "z" ];
      theme = "robbyrussell";
    };
  };
}
