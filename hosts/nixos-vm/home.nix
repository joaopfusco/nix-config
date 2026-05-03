{ ... }:

{
  imports = [
    ../../modules/home/pkgs.nix
    ../../modules/home/gui-apps.nix
    ../../modules/home/git.nix
    ../../modules/home/zsh.nix
    ../../modules/home/direnv.nix
    ../../modules/home/kitty.nix
    ../../modules/home/vim.nix
    ../../modules/home/dotnet/full.nix
  ];

  # Ignoring any other definition and using this one
  # home.stateVersion = lib.mkForce "26.05";
}
