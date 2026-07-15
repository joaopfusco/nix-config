{ pkgs, ... }:
{
  imports = [ ./config ];
  home.packages = [ pkgs.go ];
}
