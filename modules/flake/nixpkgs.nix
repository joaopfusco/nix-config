{ inputs, config, ... }:
{
  flake.overlays.unstable = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.stdenv.hostPlatform.system;
      config.allowUnfree = true;
    };
  };

  perSystem =
    { system, pkgs, ... }:
    {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        overlays = builtins.attrValues config.flake.overlays;
        config.allowUnfree = true;
      };
      legacyPackages = pkgs;
    };
}
