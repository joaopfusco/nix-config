{ config, pkgs, lib, username, ... }:

{
  imports = [
    # ./modules/git.nix
    ./modules/zsh.nix
    ./modules/starship.nix
    ./modules/direnv.nix
    ./modules/dev.nix
    ./modules/alacritty.nix
  ];

  home.username = username;
  home.homeDirectory = "/home/${username}";
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

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
}