{ config, pkgs, ... }:

{
  # echo "[ -f ~/.bashrc.nix ] && source ~/.bashrc.nix" >> ~/.bashrc
  home.file.".bashrc.nix".text = ''
    exec zsh
  '';
}