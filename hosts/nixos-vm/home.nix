{ config, pkgs, lib, ... }:

{
  imports = [
    ../../modules/cli-apps.nix
    ../../modules/gui-apps.nix
    ../../modules/git.nix
    ../../modules/zsh.nix
    ../../modules/direnv.nix
  ];
}
