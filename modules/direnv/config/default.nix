{ pkgs, lib, ... }:

{
  programs.direnv = {
    enable = true;
    package = lib.mkDefault pkgs.emptyDirectory;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };
}
