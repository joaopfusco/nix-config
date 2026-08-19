{
  flake.modules.nixos.apps =
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

      # Flatpak
      # Only turns on the service/portal — apps installed imperatively (flatpak install).
      # Run: flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
      services.flatpak.enable = true;
      xdg.portal.enable = true;
    };
}
