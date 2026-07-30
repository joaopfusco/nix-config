{
  nixpkgs,
  home-manager,
  inputs,
  username,
  mkPkgs,
  homeManager,
}:

let
  dirNames =
    path:
    builtins.attrNames (
      nixpkgs.lib.filterAttrs (name: type: type == "directory") (builtins.readDir path)
    );

  # Standalone hosts/ profiles read an optional `system` file (default: x86_64-linux).
  getProfileSystem =
    profile:
    let
      systemFile = ../hosts/${profile}/system;
    in
    if builtins.pathExists systemFile then
      nixpkgs.lib.replaceStrings [ "\n" " " ] [ "" "" ] (builtins.readFile systemFile)
    else
      "x86_64-linux";

  homeProfiles = dirNames ../hosts;
in
{
  inherit getProfileSystem homeProfiles;

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
            ../hosts/${profile}/home.nix
            homeManager
          ];
        };
    }) homeProfiles
  );
}
