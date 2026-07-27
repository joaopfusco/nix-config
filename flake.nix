{
  description = "Nix Configuration";

  inputs = {
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "https://flakehub.com/f/nix-community/home-manager/0";
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
      getProfileSystem =
        profile:
        let
          systemFile = ./home/${profile}/system;
        in
        if builtins.pathExists systemFile then
          nixpkgs.lib.replaceStrings [ "\n" " " ] [ "" "" ] (builtins.readFile systemFile)
        else
          "x86_64-linux";

      # Shared Home Manager settings
      commonHomeManager =
        { pkgs, lib, options, ... }:
        {
          config = {
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

            lib.own.mkConfigOnly =
              appName:
              lib.mkDefault (
                if options.programs.${appName}.package.type.check null then
                  null
                else
                  pkgs.emptyDirectory
              );
          };
        };

      dirNames =
        path: builtins.attrNames (nixpkgs.lib.filterAttrs (name: type: type == "directory") (builtins.readDir path));

      # Standalone Home Manager profiles
      homeProfiles = dirNames ./home;
    in
    {
      # Legacy packages for ad-hoc use (e.g. nix shell pkgs#<pkg> or nix shell pkgs#unstable.<pkg>)
      legacyPackages = nixpkgs.lib.genAttrs systems mkPkgs;

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
