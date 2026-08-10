{
  flake.modules.nixos.guiPkgs =
    { pkgs, ... }:
    {
      environment.systemPackages =
        (with pkgs; [
          libreoffice
          vlc
          obs-studio
          vscode
          dbeaver-bin
          postman
        ])
        ++ (with pkgs.unstable; [
          google-chrome
        ]);

      programs.firefox = {
        enable = true;
        package = pkgs.unstable.firefox;
      };
    };
}
