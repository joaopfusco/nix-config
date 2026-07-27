{ pkgs, ... }:
{
  home.packages = with pkgs; [
    home-manager
    nixfmt
    nixd
    devenv
  ];
}
