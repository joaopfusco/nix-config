{ config, pkgs, lib, ... }:

{
  imports = [
    # ./modules/git.nix
    ./modules/zsh.nix
    ./modules/bash.nix
    ./modules/starship.nix
    ./modules/direnv.nix
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

  targets.genericLinux.enable = true;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
}