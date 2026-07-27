{ ... }:
{
  imports = [
    # Core
    ../../modules/pkgs.nix

    # Dev tools
    ../../modules/gh.nix
    ../../modules/git.nix
    ../../modules/direnv.nix
    ../../modules/dotnet.nix

    # AI tooling
    ../../modules/claude-code

    # Shell
    ../../modules/zsh

    # GUI apps
    ../../modules/zed
    ../../modules/kitty.nix
  ];
}
