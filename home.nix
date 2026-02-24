{ config, pkgs, lib, ... }:

{
  imports = [
    # ./modules/gnome.nix
    ./modules/zsh.nix
    ./modules/git.nix
    ./modules/direnv.nix
    ./modules/mise.nix
  ];

  # Mudar quando tiver em ambiente sem gnome
  # features.gnome.enable = true;

  home.username = "joaop";
  home.homeDirectory = "/home/joaop";
  home.stateVersion = "25.11";

  home.packages = with pkgs; [
    home-manager
    wget
    curl
    neofetch
    azure-cli
  ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
}