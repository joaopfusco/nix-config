{ ... }:

{
  imports = [
    ../../modules/home/nix.nix
    ../../modules/home/pkgs/cli.nix
    ../../modules/home/git.nix
    ../../modules/home/zsh.nix
    ../../modules/home/direnv.nix
    ../../modules/home/dotnet/minimal.nix
    ../../modules/home/zed/config.nix
  ];
}
