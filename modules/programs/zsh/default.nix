{
  flake.modules.homeManager.zsh =
    { config, pkgs, ... }:
    {
      imports = [
        ./_aliases.nix
        ./_init-content.nix
        ./_oh-my-zsh.nix
      ];

      programs.zsh = {
        enable = true;
        package = pkgs.zsh;
        dotDir = "${config.xdg.configHome}/zsh";
        enableCompletion = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;
      };
    };
}
