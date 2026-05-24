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

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-stable,
      home-manager,
      darwin,
      ...
    }@inputs:
    let
      username = "joaop";
      homeStateVersion = "25.11";

      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];

      getHostSystem =
        host:
        let
          systemFile = ./hosts/${host}/system;
        in
        if builtins.pathExists systemFile then
          nixpkgs.lib.replaceStrings [ "\n" " " ] [ "" "" ] (builtins.readFile systemFile)
        else
          "x86_64-linux"; # Default

      # pkgs.pkg -> unstable
      # pkgs.stable.pkg -> stable
      mkPkgs =
        system:
        import nixpkgs {
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

      commonHomeManager =
        { pkgs }:
        {
          imports = [ inputs.nix-index-database.homeModules.nix-index ];
          nix.registry.pkgs.flake = self;
          programs.nix-index-database.comma.enable = true;
          programs.nix-index.enable = true;
          home = {
            username = username;
            homeDirectory =
              if pkgs.stdenv.hostPlatform.isDarwin then "/Users/${username}" else "/home/${username}";
            stateVersion = homeStateVersion;
          };
        };

      # All hosts
      allHosts = builtins.attrNames (
        nixpkgs.lib.filterAttrs (name: type: type == "directory") (builtins.readDir ./hosts)
      );

      # MacOS hosts
      darwinHosts = builtins.filter (
        host: builtins.pathExists (./hosts + "/${host}/darwin-configuration.nix")
      ) allHosts;
    in
    {
      # Legacy packages for ad-hoc use (e.g. nix shell pkgs#<pkg> or nix shell pkgs#stable.<pkg>)
      legacyPackages = nixpkgs.lib.genAttrs systems mkPkgs;

      # Darwin configurations
      darwinConfigurations = nixpkgs.lib.genAttrs darwinHosts (
        host:
        let
          system = getHostSystem host;
          pkgs = mkPkgs system;
        in
        darwin.lib.darwinSystem {
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
                  (commonHomeManager { inherit pkgs; })
                ];
              };
            }
          ];
        }
      );

      # Home Manager configurations
      homeConfigurations = builtins.listToAttrs (
        map (host: {
          name = "${username}@${host}";
          value =
            let
              system = getHostSystem host;
              pkgs = mkPkgs system;
            in
            home-manager.lib.homeManagerConfiguration {
              inherit pkgs;
              extraSpecialArgs = { inherit host username inputs; };
              modules = [
                ./hosts/${host}/home.nix
                (commonHomeManager { inherit pkgs; })
              ];
            };
        }) allHosts
      );
    };
}
