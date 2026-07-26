{ pkgs, ... }:
{
  imports = [ ./config ];
  programs.starship.package = pkgs.starship;
}
