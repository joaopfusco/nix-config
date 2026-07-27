{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # tools
    fastfetch
    gnumake
    tree
    eza
  ];
}
