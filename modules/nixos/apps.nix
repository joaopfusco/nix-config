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
        ])
        ++ (with pkgs.unstable; [
          google-chrome
        ]);
    };
}
