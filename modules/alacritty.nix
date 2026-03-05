{ config, lib, pkgs, ... }:

{
  programs.alacritty = {
    enable = true;
    settings = {
      terminal = {
        shell = {
          program = "${pkgs.zsh}/bin/zsh";
          args = [ "-l" ];
        };
      };
      window = {
        dimensions = { columns = 120; lines = 35; };
        padding = { x = 10; y = 10; };
      };
    };
  };
}