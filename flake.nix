{
  description = "NixOS System Configuration";

  inputs = {
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, ... }@inputs:
    let
      username = "joaop";
      stateVersion = "25.11";
      system = "x86_64-linux";

      allHosts = builtins.attrNames (
        nixpkgs.lib.filterAttrs (name: type: type == "directory") (builtins.readDir ./hosts)
      );

      # NixOS hosts
      nixosHosts = builtins.filter (
        host: builtins.pathExists (./hosts + "/${host}/configuration.nix")
      ) allHosts;

      # Standalone hosts (e.g. Ubuntu)
      standaloneHosts = builtins.filter (
        host: !builtins.pathExists (./hosts + "/${host}/configuration.nix")
      ) allHosts;

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
      nixosConfigurations = nixpkgs.lib.genAttrs nixosHosts (host:
        nixpkgs.lib.nixosSystem {
          specialArgs = { inherit host username inputs; };
          modules = [
            { 
              nixpkgs.pkgs = pkgs;
              nix.registry.unstable.flake = nixpkgs-unstable; # nix shell unstable#pkg
              nix.registry.nixpkgs.flake = nixpkgs; # nix shell nixpkgs#pkg
            }
            ./hosts/${host}/hardware-configuration.nix
            ./hosts/${host}/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit host username inputs; };
              home-manager.users.${username} = {
                imports = [ ./hosts/${host}/home.nix ];
                home.username = username;
                home.homeDirectory = "/home/${username}";
                home.stateVersion = stateVersion;
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
            {
              home.username = username;
              home.homeDirectory = "/home/${username}";
              home.stateVersion = stateVersion;
            }
          ];
        };
      }) standaloneHosts);
    };
}