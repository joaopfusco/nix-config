{ pkgs, ... }:
{
  environment.systemPackages =
    (with pkgs; [
      # stable
      libreoffice
      vlc
      obs-studio
      vscode
      dbeaver-bin
      postman
    ])
    ++ (with pkgs.unstable; [
      # unstable
      google-chrome
    ]);

  programs.firefox = {
    enable = true;
    package = pkgs.unstable.firefox;
  };
}
