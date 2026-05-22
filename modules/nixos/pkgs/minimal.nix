{ pkgs, ... }:

{
  # Install Zsh
  programs.zsh.enable = true;

  # Docker
  virtualisation.docker.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget
    curl
  ];
}
