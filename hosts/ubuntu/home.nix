{ ... }:
{
  imports = [
    ../../modules/home/config.nix
    ../../modules/home/nix.nix
    ../../modules/home/pkgs.nix
    ../../modules/home/git.nix
    ../../modules/home/zsh.nix
    ../../modules/home/direnv.nix
    ../../modules/home/dotnet/minimal.nix
    ../../modules/home/zed.nix
  ];
}
