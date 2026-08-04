{ ... }:

{
  imports = [
    # Dev tools
    ../../../home-manager/modules/gh.nix
    ../../../home-manager/modules/git.nix
    ../../../home-manager/modules/direnv.nix

    # Languages
    ../../../home-manager/modules/node.nix
    ../../../home-manager/modules/python.nix
    ../../../home-manager/modules/dotnet

    # CLI apps
    ../../../home-manager/modules/cli.nix
    ../../../home-manager/modules/zsh
    ../../../home-manager/modules/starship
    ../../../home-manager/modules/claude-code

    # GUI apps
    ../../../home-manager/modules/zed-editor
    ../../../home-manager/modules/kitty
    ../../../home-manager/modules/flameshot
    ../../../home-manager/modules/copyq
  ];
}
