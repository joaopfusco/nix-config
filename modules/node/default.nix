{ pkgs, ... }:
{
  imports = [ ./config ];
  home.packages = with pkgs; [
    nodejs_24
    pnpm
  ];
}
