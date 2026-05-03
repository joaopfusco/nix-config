{ ... }:

{
  imports = [
    ../../modules/darwin/system.nix
    ../../modules/darwin/user.nix
    ../../modules/darwin/pkgs.nix
  ];

  # System version
  system.stateVersion = 5;
}
