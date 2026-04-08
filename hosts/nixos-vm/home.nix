{ config, pkgs, lib, ... }:

{
  imports = [
    ../../modules/user/pkgs/cli.nix
    ../../modules/user/pkgs/gui.nix
    ../../modules/user/git.nix
    ../../modules/user/zsh.nix
    ../../modules/user/direnv.nix
    ../../modules/user/kitty.nix
  ];

  # Ignoring any other definition and using this one
  # home.stateVersion = lib.mkForce "26.05";
}
