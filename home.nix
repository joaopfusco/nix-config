{ config, pkgs, lib, username, ... }:

{
  imports = [
    ./modules/gnome.nix
    ./modules/git.nix
    ./modules/zsh.nix
    ./modules/starship.nix
    ./modules/direnv.nix
    ./modules/dev.nix
    ./modules/pwas.nix
    ./modules/alacritty.nix
  ];

  # Enable the custom GNOME module
  features.gnome.enable = true;

  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "25.11";

  home.packages = with pkgs; [
    # Basic utilities
    home-manager
    fastfetch
    papirus-icon-theme

    # GUI applications
    libreoffice
    alacarte
    google-chrome
    discord
    obs-studio
    zoom-us
    vlc

    # Development GUI applications
    vscode
    antigravity
    dbeaver-bin
    postman
  ];
}
