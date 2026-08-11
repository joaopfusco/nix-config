{
  flake.modules.nixos.pkgs =
    { pkgs, ... }:
    {
      environment.systemPackages =
        (with pkgs; [
          wget
          curl
          btop
          distrobox
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
