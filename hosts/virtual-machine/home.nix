{ ... }:

{
  imports = [
    # Dev tools
    ../../modules/home/gh.nix
    ../../modules/home/git.nix
    ../../modules/home/direnv.nix

    # Languages
    ../../modules/home/node.nix
    ../../modules/home/python.nix
    ../../modules/home/dotnet/config

    # CLI apps
    ../../modules/home/cli.nix
    ../../modules/home/zsh
    ../../modules/home/starship
    ../../modules/home/claude-code

    # GUI apps
    ../../modules/home/zed-editor
    ../../modules/home/kitty
    ../../modules/home/flameshot
    ../../modules/home/copyq
  ];
}
