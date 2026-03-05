{ config, pkgs, ... }:

{
  home.file.".aliases.nix".text = ''
    alias ll="ls -l"
    alias la="ls -la"
    alias cls="clear"
    alias home-switch="home-manager switch --flake .#joaop"
    alias vm-status="systemctl status libvirtd"
    alias vm-start="sudo systemctl start libvirtd"
    alias vm-stop="sudo systemctl stop 'libvirtd*'"
  '';

  # echo "[ -f ~/.bashrc.nix ] && source ~/.bashrc.nix" >> ~/.bashrc
  home.file.".bashrc.nix".text = ''
    # Aliases
    [ -f ~/.aliases.nix ] && source ~/.aliases.nix

    # Starship
    eval "$(starship init bash)"

    # Direnv
    eval "$(direnv hook bash)"
  '';
}