{ pkgs, ... }:

{
  home.packages = with pkgs; [
    home-manager
    nixfmt
    alejandra
    nixd
    statix
  ];
}
