{ ... }:
{
  imports = [
    # Core
    ../../modules/nix.nix
    ../../modules/tools.nix

    # Dev tools
    ../../modules/gh.nix
    ../../modules/git.nix
    ../../modules/direnv.nix

    # Languages
    ../../modules/dotnet.nix
    ../../modules/node.nix
    ../../modules/python.nix

    # AI tooling
    ../../modules/claude-code/config
    ../../modules/codex.nix

    # Shell
    ../../modules/zsh

    # GUI apps
    ../../modules/zed/config
    ../../modules/kitty/config
  ];
}
