{ inputs, ... }:
{
  flake.modules.nixos.base =
    { config, ... }:
    {
      imports = [ inputs.home-manager.nixosModules.home-manager ];
      modules = [
        {
          nixpkgs.config.allowUnfree = true;
          nixpkgs.overlays = [ config.flake.overlays.default ];
        }
      ];
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs = { inherit inputs; };
      };
    };
}