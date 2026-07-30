{
  nixpkgs,
  home-manager,
  inputs,
  username,
  mkPkgs,
  homeManager,
  overlays,
}:

let
  dirNames =
    path:
    builtins.attrNames (
      nixpkgs.lib.filterAttrs (name: type: type == "directory") (builtins.readDir path)
    );

  getProfileSystem =
    profile:
    let
      systemFile = ../home/${profile}/system;
    in
    if builtins.pathExists systemFile then
      nixpkgs.lib.replaceStrings [ "\n" " " ] [ "" "" ] (builtins.readFile systemFile)
    else
      "x86_64-linux";

  homeProfiles = dirNames ../home;
  nixosHosts = dirNames ../hosts;
in
{
  inherit
    getProfileSystem
    homeProfiles
    nixosHosts
    ;

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
            ../home/${profile}/home.nix
            homeManager
          ];
        };
    }) homeProfiles
  );

  nixosConfigurations = builtins.listToAttrs (
    map (
      host:
      let
        homeFile = ../hosts/${host}/home.nix;
        hasHomeManager = builtins.pathExists homeFile;
      in
      {
        name = host;
        value = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit host username inputs; };
          modules = [
            ../hosts/${host}/hardware-configuration.nix
            ../hosts/${host}/configuration.nix
            {
              nixpkgs.config.allowUnfree = true;
              nixpkgs.overlays = overlays;
            }
          ]
          ++ nixpkgs.lib.optionals hasHomeManager [
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = { inherit host username inputs; };
                sharedModules = [ homeManager ];
                users.${username} = import homeFile;
              };
            }
          ];
        };
      }
    ) nixosHosts
  );
}
