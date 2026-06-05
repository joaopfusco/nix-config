{ ... }:
{
  imports = [
    ../../modules/nix.nix
    ../../modules/pkgs.nix
    ../../modules/git.nix
    ../../modules/zsh.nix
    ../../modules/direnv.nix
    ../../modules/claude.nix
    ../../modules/dotnet/minimal.nix
    ../../modules/zed.nix
  ];
}
