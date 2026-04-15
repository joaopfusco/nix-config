{ config, pkgs, lib, username, ... }:

{
  imports = [
    ../../modules/home/pkgs/cli.nix
    ../../modules/home/git.nix
    ../../modules/home/zsh.nix
    ../../modules/home/direnv.nix
    ../../modules/home/kitty.nix
    ../../modules/home/nixvim.nix
    ../../modules/home/dotnet/minimal.nix
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
