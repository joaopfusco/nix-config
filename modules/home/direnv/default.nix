{ pkgs, ... }:
{
  imports = [ ./config ];
  programs.direnv.package = pkgs.direnv;
}
