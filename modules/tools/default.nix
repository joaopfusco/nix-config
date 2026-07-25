{ pkgs, ... }:
{
  home.packages = with pkgs; [
    fastfetch
    gnumake
    tree
  ];
}
