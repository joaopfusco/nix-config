{ pkgs, ... }:
{
  home.packages = with pkgs; [
    fastfetch
    gnumake
    eza
  ];
}
