{
  self,
  username,
  homeStateVersion,
}:

{
  pkgs,
  lib,
  options,
  ...
}:
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
        if options.programs.${appName}.package.type.check null then null else pkgs.emptyDirectory
      );
  };
}
