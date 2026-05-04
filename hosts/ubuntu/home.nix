{ pkgs, ... }:

{
  imports = [
    ../../modules/home/pkgs.nix
    ../../modules/home/git.nix
    ../../modules/home/zsh.nix
    ../../modules/home/direnv.nix
    ../../modules/home/vim.nix
    ../../modules/home/dotnet/full.nix
    ../../modules/home/kitty.nix
    ../../modules/home/zed.nix
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
