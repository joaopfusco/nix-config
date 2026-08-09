{ inputs, ... }:
let
  overlays = [
    (final: prev: {
      unstable = import inputs.nixpkgs-unstable {
        system = final.stdenv.hostPlatform.system;
        config.allowUnfree = true;
      };
    })
  ];
  mkPkgs = system: import inputs.nixpkgs { inherit system overlays; config.allowUnfree = true; };
in
{
  systems = [
    "x86_64-linux"
    "aarch64-linux"
    "aarch64-darwin"
    "x86_64-darwin"
  ];

  flake.overlays.default = builtins.head overlays;

  perSystem = { system, ... }: {
    _module.args.pkgs = mkPkgs system;
    legacyPackages = mkPkgs system;
  };
}
