{ pkgs, ... }:
{
  imports = [ ./config ];
  programs.git.package = pkgs.git;
}
