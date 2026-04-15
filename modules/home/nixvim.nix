{ pkgs, inputs, ... }:

{
  imports = [
    inputs.nixvim.homeModules.nixvim
  ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;

    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    opts = {
      shell = "${pkgs.zsh}/bin/zsh";
    };

    colorschemes.catppuccin = {
      enable = true;
      settings.flavour = "mocha";
    };
  };
}