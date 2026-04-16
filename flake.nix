{
  description = "Nix Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "https://flakehub.com/f/NixOS/nixpkgs/0";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = { self, nixpkgs, nixpkgs-stable, home-manager, darwin, nixos-wsl, ... }@inputs:
    let
      username = "joaop";
      homeStateVersion = "25.11";

      getHostSystem = host: 
        let 
          systemFile = ./hosts/${host}/system;
        in 
          if builtins.pathExists systemFile 
          then nixpkgs.lib.replaceStrings ["\n" " "] ["" ""] (builtins.readFile systemFile)
          else "x86_64-linux"; # Default

      # pkgs.pkg -> unstable
      # pkgs.stable.pkg -> stable
      mkPkgs = system: import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [
          (final: prev: {
            stable = import nixpkgs-stable {
              inherit system;
              config.allowUnfree = true;
            };
          })
        ];
      };

      commonHomeManager = { host, system }: {
        nix.registry.pkgs.flake = self;
        home = {
          username = username;
          homeDirectory = if nixpkgs.lib.hasInfix "darwin" system 
                         then "/Users/${username}" 
                         else "/home/${username}";
          stateVersion = homeStateVersion;
        };
      };

      # All hosts
      allHosts = builtins.attrNames (
        nixpkgs.lib.filterAttrs (name: type: type == "directory") (builtins.readDir ./hosts)
      );

      # NixOS hosts
      nixosHosts = builtins.filter (
        host: builtins.pathExists (./hosts + "/${host}/configuration.nix")
      ) allHosts;

      # WSL hosts
      wslHosts = builtins.filter (
        host: builtins.pathExists (./hosts + "/${host}/wsl-configuration.nix")
      ) allHosts;

      # MacOS hosts
      darwinHosts = builtins.filter (
        host: builtins.pathExists (./hosts + "/${host}/darwin-configuration.nix")
      ) allHosts;
    in {
      # Legacy packages for ad-hoc use (e.g. nix shell pkgs#<pkg> or nix shell pkgs#stable.<pkg>)
      legacyPackages = nixpkgs.lib.genAttrs [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ] (system: mkPkgs system);

      # NixOS configurations
      nixosConfigurations = nixpkgs.lib.genAttrs (nixosHosts ++ wslHosts) (host:
        let 
          isWsl = builtins.pathExists (./hosts + "/${host}/wsl-configuration.nix");
          system = getHostSystem host;
          pkgs = mkPkgs system;
        in nixpkgs.lib.nixosSystem {
          specialArgs = { inherit host username inputs; };
          modules = [
            { nixpkgs.pkgs = pkgs; }
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit host username inputs; };
              home-manager.users.${username} = {
                imports = [ 
                  ./hosts/${host}/home.nix 
                  (commonHomeManager { inherit host system; }) 
                ];
              };
            }
          ] ++ (if isWsl then [
            nixos-wsl.nixosModules.default
            ./hosts/${host}/wsl-configuration.nix
          ] else [
            ./hosts/${host}/hardware-configuration.nix
            ./hosts/${host}/configuration.nix
          ]);
        }
      );

      # Darwin configurations
      darwinConfigurations = nixpkgs.lib.genAttrs darwinHosts (host:
        let 
          system = getHostSystem host;
          pkgs = mkPkgs system;
        in darwin.lib.darwinSystem {
          specialArgs = { inherit host username inputs; };
          modules = [
            { nixpkgs.pkgs = pkgs; }
            ./hosts/${host}/darwin-configuration.nix
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit host username inputs; };
              home-manager.users.${username} = {
                imports = [ 
                  ./hosts/${host}/home.nix 
                  (commonHomeManager { inherit host system; }) 
                ];
              };
            }
          ];
        }
      );

      # Home Manager configurations for non-NixOS hosts
      homeConfigurations = builtins.listToAttrs (map (host: {
        name = "${username}@${host}";
        value = let 
          system = getHostSystem host;
          pkgs = mkPkgs system;
        in home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit host username inputs; }; 
          modules = [ 
            ./hosts/${host}/home.nix 
            (commonHomeManager { inherit host system; })
          ];
        };
      }) allHosts);
    };
}