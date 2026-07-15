{ pkgs, ... }:
{
  imports = [ ./config ];
  programs.zed-editor.package = pkgs.zed-editor;
}
