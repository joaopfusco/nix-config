{ pkgs, ... }:

{
  home.packages = with pkgs; [
    dbeaver-bin
    obs-studio
    alacarte
  ];
}