{ config, pkgs, lib, username, ... }:

{
  imports = [
    ./packages/gui.nix
    ./packages/cli.nix
    # ./modules/git.nix
    ./modules/direnv.nix
    ./modules/kitty.nix
    ./modules/starship.nix
    ./modules/zsh.nix
  ];

  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "25.11";

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