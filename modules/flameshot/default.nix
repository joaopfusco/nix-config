{ pkgs, ... }:
{
  imports = [ ./config ];
  home.packages = with pkgs; [ flameshot ];
}
