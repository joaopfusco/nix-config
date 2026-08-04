{ pkgs, ... }:
{
  programs.firefox.enable = true;

  environment.systemPackages = with pkgs; [
    libreoffice
    vlc
    obs-studio
    google-chrome
    vscode
    dbeaver-bin
    postman
  ];
}
