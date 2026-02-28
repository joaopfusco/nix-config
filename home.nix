{ config, pkgs, lib, ... }:

{
  imports = [
    ./modules/git.nix
    ./modules/zsh.nix
    ./modules/starship.nix
    ./modules/direnv.nix
    ./modules/mise.nix
  ];

  home.username = "joaop";
  home.homeDirectory = "/var/home/joaop/box";
  home.stateVersion = "25.11";

  home.packages = with pkgs; [
    home-manager
    fastfetch
    uv
    # azure-cli
  ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
}