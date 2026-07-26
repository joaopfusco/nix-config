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
    ../../modules/dotnet
    ../../modules/go/config
    ../../modules/rust/config

    # AI tooling
    ../../modules/claude-code/config

    # Shell
    ../../modules/zsh/config
    ../../modules/starship

    # GUI apps
    ../../modules/kitty/config
    ../../modules/zed/config
    ../../modules/flameshot/config
    ../../modules/copyq/config
  ];
}
