{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # nix
    home-manager
    nixfmt
    nixd
    devenv
  ];
}
