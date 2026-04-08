{ config, pkgs, lib, username, ... }:

{
  imports = [
    ../../modules/user/pkgs/cli.nix
    ../../modules/user/git.nix
    ../../modules/user/zsh.nix
    ../../modules/user/direnv.nix
    ../../modules/user/kitty.nix
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
