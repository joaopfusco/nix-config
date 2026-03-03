{ config, lib, pkgs, ... }:

{
  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        dimensions = { columns = 120; lines = 35; };
        padding = { x = 10; y = 10; };
      };
    };
  };
}