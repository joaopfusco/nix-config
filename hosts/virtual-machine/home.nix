{ ... }:

{
  imports = [
    # Dev tools
    ../../modules/home/gh.nix
    ../../modules/home/git.nix
    ../../modules/home/direnv.nix

    # Languages
    ../../modules/home/dotnet.nix
    ../../modules/home/node.nix
    ../../modules/home/python.nix

    # CLI apps
    ../../modules/home/cli.nix
    ../../modules/home/zsh
    ../../modules/home/claude-code

    # GUI apps
    ../../modules/home/zed-editor
    ../../modules/home/kitty
    ../../modules/home/flameshot
    ../../modules/home/copyq
  ];
}
