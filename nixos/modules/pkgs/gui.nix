{ pkgs, ... }:
{
  programs.firefox = {
    enable = true;
    package = pkgs.unstable.firefox;
  };
  environment.systemPackages = [
    # stable
    pkgs.libreoffice
    pkgs.vlc
    pkgs.obs-studio
    pkgs.vscode
    pkgs.dbeaver-bin
    pkgs.postman
    # unstable
    pkgs.unstable.google-chrome
  ];
}
