{ pkgs, ... }:
{
  home.packages = with pkgs; [
    fastfetch
    gnumake
    terraform
    azure-cli
  ];
}
