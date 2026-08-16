{ inputs, config, ... }:
let
  overlays = builtins.attrValues config.flake.overlays;
in
{
  flake.modules.darwin.base = {
    _module.args.inputs = inputs;
    imports = [ inputs.home-manager.darwinModules.home-manager ];
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
    };
    nixpkgs.config.allowUnfree = true;
    nixpkgs.overlays = overlays;
  };
}
