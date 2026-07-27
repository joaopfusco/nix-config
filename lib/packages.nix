{ nixpkgs, nixpkgs-unstable }:

let
  systems = [
    "x86_64-linux"
    "aarch64-linux"
    "aarch64-darwin"
    "x86_64-darwin"
  ];

  # pkgs.pkg -> stable
  # pkgs.unstable.pkg -> unstable
  overlays = [
    (final: prev: {
      unstable = import nixpkgs-unstable {
        system = final.stdenv.hostPlatform.system;
        config.allowUnfree = true;
      };
    })
  ];

  mkPkgs =
    system:
    import nixpkgs {
      inherit system overlays;
      config.allowUnfree = true;
    };
in
{
  inherit systems overlays mkPkgs;

  # nix shell pkgs#<pkg> or nix shell pkgs#unstable.<pkg>
  legacyPackages = nixpkgs.lib.genAttrs systems mkPkgs;
}
