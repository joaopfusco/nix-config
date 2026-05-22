{ ... }:

{
  imports = [
    ../../modules/home/nix.nix
    ../../modules/home/pkgs/cli.nix
    ../../modules/home/git.nix
    ../../modules/home/zsh.nix
    ../../modules/home/direnv.nix
    ../../modules/home/dotnet
  ];

  # Ignoring any other definition and using this one
  # home.stateVersion = lib.mkForce "26.05";
}
