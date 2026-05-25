{
  description = "Nix Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "https://flakehub.com/f/NixOS/nixpkgs/0";

    home-manager = {
      url = "github:nix-community/home-manager";
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

      homeManagerModule =
        { pkgs }:
        {
          imports = [
            inputs.nix-index-database.homeModules.nix-index
          ];

          nix.registry.pkgs.flake = self;

          targets.genericLinux.enable = pkgs.stdenv.hostPlatform.isLinux;

          programs.nix-index-database.comma.enable = true;
          programs.nix-index.enable = true;

          home = {
            username = username;
            homeDirectory =
              if pkgs.stdenv.hostPlatform.isDarwin then "/Users/${username}" else "/home/${username}";
            stateVersion = homeStateVersion;
            sessionVariables = {
              NIX_PATH = "nixpkgs=${pkgs.path}";
            };
          };

          nix.gc = {
            automatic = true;
            dates = "weekly";
            options = "--delete-older-than 7d";
          };
        };

      # Hosts
      hosts = builtins.attrNames (
        nixpkgs.lib.filterAttrs (name: type: type == "directory") (builtins.readDir ./hosts)
      );
    in
    {
      # Legacy packages for ad-hoc use (e.g. nix shell pkgs#<pkg> or nix shell pkgs#stable.<pkg>)
      legacyPackages = nixpkgs.lib.genAttrs systems mkPkgs;

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
                (homeManagerModule { inherit pkgs; })
              ];
            };
        }) hosts
      );
    };
}
