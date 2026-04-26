{ pkgs, ... }:

{
  programs.zed-editor = {
    enable = true;
    package = pkgs.zed-editor;
    # package = pkgs.zed-editor-fhs;
  };
}