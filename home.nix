{ config, pkgs, lib, username, ... }:

{
  imports = [
    # ./modules/git.nix
    ./modules/flatpak.nix
    ./modules/zsh.nix
    ./modules/starship.nix
    ./modules/direnv.nix
    ./modules/dev.nix
    ./modules/kitty.nix
  ];

  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "25.11";

  home.packages = with pkgs; [
    home-manager
    fastfetch
  ];

  services.myflatpak = {
    enable = true;
    uninstallUnmanaged = true;

    remotes = [{
      name = "flathub";
      location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
    }];

    packages = [
      "com.github.tchx84.Flatseal"
      "org.videolan.VLC"
      "com.discordapp.Discord"
      "io.dbeaver.DBeaverCommunity"
      "org.libreoffice.LibreOffice"
      "com.obsproject.Studio"
      "page.codeberg.libre_menu_editor.LibreMenuEditor"
      "com.ranfdev.DistroShelf"
      "us.zoom.Zoom"
    ];

    update.auto.enable = true;
  };

  home.sessionVariables = {
    NIX_PATH = "nixpkgs=${pkgs.path}";
  };

  targets.genericLinux.enable = true;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
}