{
  description = "Nix Configuration";

  inputs = {
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "https://flakehub.com/f/nix-community/home-manager/0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware = {
      url = "github:nixos/nixos-hardware";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      ...
    }@inputs:
    let
      username = "joaop";
      homeStateVersion = "26.05";

      packages = import ./lib/packages.nix {
        inherit nixpkgs nixpkgs-unstable;
      };

      homeManager = import ./lib/home-manager.nix {
        inherit self username homeStateVersion;
      };

      profiles = import ./lib/profiles.nix {
        inherit
          nixpkgs
          home-manager
          inputs
          username
          homeManager
          ;
        inherit (packages) mkPkgs overlays;
      };
    in
    {
      inherit (packages) legacyPackages;
      inherit (profiles) homeConfigurations nixosConfigurations;
    };
}
