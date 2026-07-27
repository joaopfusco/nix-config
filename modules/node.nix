{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # node
    nodejs_24
    pnpm
  ];
}
