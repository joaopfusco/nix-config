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

      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];

      # pkgs.pkg -> stable
      # pkgs.unstable.pkg -> unstable
      overlays = [
        (final: prev: {
          unstable = import nixpkgs-unstable {
            system = final.stdenv.hostPlatform.system;
            config.allowUnfree = true;
          };
        })
      ];

      mkPkgs =
        system:
        import nixpkgs {
          inherit system overlays;
          config.allowUnfree = true;
        };

      # Standalone home/ profiles read an optional `system` file (default: x86_64-linux).
      # NixOS hosts/ don't need this: hardware-configuration.nix sets nixpkgs.hostPlatform directly.
      getProfileSystem =
        profile:
        let
          systemFile = ./home/${profile}/system;
        in
        if builtins.pathExists systemFile then
          nixpkgs.lib.replaceStrings [ "\n" " " ] [ "" "" ] (builtins.readFile systemFile)
        else
          "x86_64-linux";

      # Shared Home Manager settings, used both standalone (home/) and embedded in NixOS (hosts/)
      commonHomeManager =
        { pkgs, ... }:
        {
          nix.registry.pkgs.flake = self;
          targets.genericLinux.enable = pkgs.stdenv.hostPlatform.isLinux;
          home = {
            inherit username;
            homeDirectory =
              if pkgs.stdenv.hostPlatform.isLinux then "/home/${username}" else "/Users/${username}";
            stateVersion = homeStateVersion;
            sessionVariables.NIX_PATH = "nixpkgs=${pkgs.path}";
          };
          nix.gc = {
            automatic = true;
            dates = "weekly";
            options = "--delete-older-than 7d";
          };
        };

      dirNames =
        path: builtins.attrNames (nixpkgs.lib.filterAttrs (name: type: type == "directory") (builtins.readDir path));

      # NixOS machines (Nix owns the whole OS)
      nixosHosts = dirNames ./hosts;

      # Standalone Home Manager profiles (any non-NixOS Linux distro, or macOS without nix-darwin)
      homeProfiles = dirNames ./home;
    in
    {
      # Legacy packages for ad-hoc use (e.g. nix shell pkgs#<pkg> or nix shell pkgs#unstable.<pkg>)
      legacyPackages = nixpkgs.lib.genAttrs systems mkPkgs;

      # NixOS system configurations, with Home Manager embedded as a NixOS module
      nixosConfigurations = builtins.listToAttrs (
        map (host: {
          name = host;
          value = nixpkgs.lib.nixosSystem {
            specialArgs = { inherit host username inputs; };
            modules = [
              ./hosts/${host}/hardware-configuration.nix
              ./hosts/${host}/configuration.nix
              {
                nixpkgs.config.allowUnfree = true;
                nixpkgs.overlays = overlays;
              }
              home-manager.nixosModules.home-manager
              {
                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  extraSpecialArgs = { inherit host username inputs; };
                  sharedModules = [ commonHomeManager ];
                  users.${username} = import ./hosts/${host}/home.nix;
                };
              }
            ];
          };
        }) nixosHosts
      );

      # Standalone Home Manager configurations
      homeConfigurations = builtins.listToAttrs (
        map (profile: {
          name = "${username}@${profile}";
          value =
            let
              system = getProfileSystem profile;
              pkgs = mkPkgs system;
            in
            home-manager.lib.homeManagerConfiguration {
              inherit pkgs;
              extraSpecialArgs = {
                host = profile;
                inherit username inputs;
              };
              modules = [
                ./home/${profile}/home.nix
                commonHomeManager
              ];
            };
        }) homeProfiles
      );
    };
}
