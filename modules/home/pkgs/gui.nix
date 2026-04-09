{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # GUI applications
    vscode
    obs-studio
    dbeaver-bin
    distroshelf
    postman
  ];
}
