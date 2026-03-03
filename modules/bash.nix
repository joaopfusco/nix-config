{ config, pkgs, ... }:

{
  # touch ~/.bashrc.nix
  # echo "[ -f ~/.bashrc.nix ] && source ~/.bashrc.nix" >> ~/.bashrc
  home.file.".bashrc.nix".text = ''
    # Aliases gerenciados pelo home-manager
    alias ll="ls -l"
    alias la="ls -la"
    alias cls="clear"
    alias home-update="home-manager switch --flake .#joaop"
    alias vm-status="systemctl status libvirtd"
    alias vm-start="sudo systemctl start libvirtd"
    alias vm-stop="sudo systemctl stop 'libvirtd*'"

    # Starship prompt
    if command -v starship &> /dev/null; then
      eval "$(starship init bash)"
    fi

    # Direnv
    if command -v direnv &> /dev/null; then
      eval "$(direnv hook bash)"
    fi
  '';
}