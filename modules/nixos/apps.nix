{
  flake.modules.nixos.apps =
    { pkgs, ... }:
    {
      environment.systemPackages =
        (with pkgs; [
          libreoffice
          vlc
          obs-studio
          vscode-fhs
          dbeaver-bin
          postman
        ])
        ++ (with pkgs.unstable; [
          google-chrome
        ]);
    };
}
