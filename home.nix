{ config, pkgs, lib, ... }:

{
  imports = [
    # ./modules/git.nix
    # ./modules/flatpak.nix
    ./modules/gnome.nix
    ./modules/zsh.nix
    ./modules/bash.nix
    ./modules/starship.nix
    ./modules/direnv.nix
    ./modules/dev.nix
    ./modules/alacritty.nix
  ];

  home.username = "joaop";
  home.homeDirectory = "/home/joaop";
  home.stateVersion = "25.11";

  home.packages = with pkgs; [
    home-manager
    fastfetch
    uv
  ];

  home.sessionVariables = {
    NIX_PATH = "nixpkgs=${pkgs.path}";
  };

  targets.genericLinux.enable = true;

  features.gnome.enable = true;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
}