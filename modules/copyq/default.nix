{ pkgs, ... }:
{
  imports = [ ./config ];
  home.packages = [ pkgs.copyq ];
}
