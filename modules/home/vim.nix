{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;

    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    # homeStateVersion <= 25.11
    withRuby = false;
    withPython3 = false;
  };

  /*
  git clone https://github.com/LazyVim/starter ~/nix-config/modules/home/nvim
  rm -rf ~/nix-config/modules/home/nvim/.git
  */
  # xdg.configFile."nvim".source = ./nvim;
}