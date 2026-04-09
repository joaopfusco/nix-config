{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # GUI applications
    vlc
    libreoffice
    obs-studio
    google-chrome
    vscode
    dbeaver-bin
    postman
    distroshelf
  ];
}
