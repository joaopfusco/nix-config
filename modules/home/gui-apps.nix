{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # GUI applications
    vlc
    libreoffice
    google-chrome
    vscode
    obs-studio
    dbeaver-bin
    distrobox
    distroshelf
    postman
  ];
}
