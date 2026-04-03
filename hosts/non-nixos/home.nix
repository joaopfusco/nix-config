{ config, pkgs, lib, username, ... }:

{
  imports = [
    ../../modules/cli-apps.nix
    ../../modules/git.nix
    ../../modules/zsh.nix
    ../../modules/direnv.nix
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
