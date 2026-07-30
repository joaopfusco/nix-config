{ pkgs, ... }:
{
  imports = [ ./config ];
  programs.kitty.package = pkgs.kitty;
}
