{ ... }:
{
  imports = [
    # Dev tools
    ../../modules/gh.nix
    ../../modules/git.nix
    ../../modules/direnv.nix

    # Languages
    ../../modules/node.nix
    ../../modules/python.nix
    ../../modules/dotnet/config

    # CLI apps
    ../../modules/cli.nix
    ../../modules/zsh
    ../../modules/starship
    ../../modules/claude-code/config

    # GUI apps
    ../../modules/zed-editor/config
    ../../modules/kitty/config
  ];
}
