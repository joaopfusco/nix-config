{ pkgs, ... }:
{
  imports = [ ./config ];
  programs.zsh.package = pkgs.zsh;
}
