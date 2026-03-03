{ config, pkgs, lib, username, ... }:

{
  imports = [
    ./modules/gnome.nix
    ./modules/git.nix
    ./modules/zsh.nix
    ./modules/starship.nix
    ./modules/direnv.nix
    ./modules/mise.nix
    ./modules/pwas.nix
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
    alacritty
    libreoffice
    google-chrome
    discord
    obs-studio
    zoom-us
    vlc

    # Development tools
    uv

    # Development GUI applications
    vscode
    antigravity
    dbeaver-bin
    postman
  ];
}