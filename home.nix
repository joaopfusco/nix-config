{ config, pkgs, lib, username, ... }:

{
  imports = [
    ./modules/apps.nix
    ./modules/dev.nix
    ./modules/direnv.nix
    # ./modules/git.nix
    ./modules/kitty.nix
    ./modules/starship.nix
    ./modules/zsh.nix
  ];

  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "25.11";

  home.packages = with pkgs; [
    home-manager
    fastfetch
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