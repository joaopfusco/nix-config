{ pkgs, ... }:
{
  imports = [ ./config ];
  programs.claude-code.package = pkgs.claude-code;
}
