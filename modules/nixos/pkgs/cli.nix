{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    wget
    curl
    btop
    distrobox
  ];
}
