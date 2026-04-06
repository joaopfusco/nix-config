{
  description = "NixOS System Configuration";

  inputs = {
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0"; # Stable Nixpkgs (use 0.1 for unstable)
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "https://flakehub.com/f/nix-community/home-manager/0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, ... }@inputs:
    let
      username = "joaop";
      stateVersion = "25.11";
      system = "x86_64-linux";

      commonHomeManager = {
        nix.registry.pkgs.flake = self; # nix shell pkgs#pkg or nix shell pkgs#unstable.pkg 
        home.username = username;
        home.homeDirectory = "/home/${username}";
        home.stateVersion = stateVersion;
      };

      # All hosts
      allHosts = builtins.attrNames (
        nixpkgs.lib.filterAttrs (name: type: type == "directory") (builtins.readDir ./hosts)
      );

      # NixOS hosts
      nixosHosts = builtins.filter (
        host: builtins.pathExists (./hosts + "/${host}/configuration.nix")
      ) allHosts;

      # Standalone hosts (e.g. Ubuntu)
      standaloneHosts = allHosts;

      # Overlay to add unstable packages under pkgs.unstable
      overlay-unstable = final: prev: {
        unstable = import nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
        };
      };

      # pkgs.pkg -> stable
      # pkgs.unstable.pkg -> unstable
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [ overlay-unstable ];
      };
    in {
      legacyPackages.${system} = pkgs;
      nixosConfigurations = nixpkgs.lib.genAttrs nixosHosts (host:
        nixpkgs.lib.nixosSystem {
          specialArgs = { inherit host username inputs; };
          modules = [
            { 
              nixpkgs.pkgs = pkgs;
              nix.registry.pkgs.flake = self; # nix shell pkgs#pkg or nix shell pkgs#unstable.pkg 
            }
            ./hosts/${host}/hardware-configuration.nix
            ./hosts/${host}/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit host username inputs; };
              home-manager.users.${username} = {
                imports = [ 
                  ./hosts/${host}/home.nix
                  commonHomeManager
                ];
              };
            }
          ];
        }
      );
      homeConfigurations = builtins.listToAttrs (map (host: {
        name = "${username}@${host}";
        value = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit host username inputs; }; 
          modules = [ 
            ./hosts/${host}/home.nix 
            commonHomeManager
          ];
        };
      }) standaloneHosts);
    };
}