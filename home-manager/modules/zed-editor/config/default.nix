{ config, ... }:
{
  imports = [
    ./keymap.nix
    ./settings.nix
  ];

  programs.zed-editor = {
    enable = true;
    package = config.lib.own.mkConfigOnly "zed-editor";
  };
}
