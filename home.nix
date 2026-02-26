{ config, pkgs, lib, ... }:

{
  imports = [
    # ./modules/gnome.nix
    # ./modules/git.nix
    ./modules/zsh.nix
    ./modules/starship.nix
    ./modules/direnv.nix
    ./modules/mise.nix
    ./modules/neovim.nix
  ];

  # Mudar quando tiver em ambiente sem gnome
  # features.gnome.enable = true;

  home.username = "joaop";
  home.homeDirectory = "/home/joaop";
  home.stateVersion = "25.11";

  home.packages = with pkgs; [
    home-manager
    fastfetch
    # azure-cli
  ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
}