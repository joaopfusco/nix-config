{ config, pkgs, lib, ... }:

{
  imports = [
    ../../modules/home/pkgs/cli.nix
    ../../modules/home/pkgs/gui.nix
    ../../modules/home/git.nix
    ../../modules/home/zsh.nix
    ../../modules/home/direnv.nix
    ../../modules/home/kitty.nix
    ../../modules/home/nixvim.nix
    ../../modules/home/dotnet/complete.nix
  ];

  # Ignoring any other definition and using this one
  # home.stateVersion = lib.mkForce "26.05";
}
