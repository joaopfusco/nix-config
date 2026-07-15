{ pkgs, ... }:
{
  imports = [ ./config ];
  programs.gh.package = pkgs.gh;
}
