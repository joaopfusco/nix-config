{ ... }:
{
  imports = [
    # Dev tools
    ../../modules/gh.nix
    ../../modules/git.nix
    ../../modules/direnv.nix

    # Languages
    ../../modules/dotnet.nix
    ../../modules/node.nix
    ../../modules/python.nix

    # CLI apps
    ../../modules/cli.nix
    ../../modules/zsh
    ../../modules/claude-code/config

    # GUI apps
    ../../modules/zed-editor/config
    ../../modules/kitty/config
    ../../modules/flameshot/config
    ../../modules/copyq/config
  ];
}
