{ ... }:
{
  imports = [
    # Core
    ../../modules/nix
    ../../modules/tools

    # Dev tools
    ../../modules/gh
    ../../modules/git
    ../../modules/direnv

    # Languages
    ../../modules/python
    ../../modules/node
    ../../modules/go/config
    ../../modules/rust/config
    ../../modules/dotnet/config

    # AI tooling
    ../../modules/claude-code/config

    # Shell
    ../../modules/zsh/config

    # GUI apps
    ../../modules/kitty/config
    ../../modules/zed/config
  ];
}
