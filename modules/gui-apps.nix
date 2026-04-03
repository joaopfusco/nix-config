{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # System utilities
    papirus-icon-theme

    # GUI applications
    vlc
    libreoffice
    alacarte
    obs-studio
    google-chrome
    vscode
    dbeaver-bin
    postman
  ];
}
