{ pkgs, ... }:
{
  imports = [ ./config ];
  home.packages = [ pkgs.flameshot ];
}
