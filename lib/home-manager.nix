{
  self,
  username,
  homeStateVersion,
}:

{
  pkgs,
  lib,
  options,
  osConfig,
  ...
}:
{
  config = lib.mkMerge [
    {
      nix.registry.pkgs.flake = self;
      home = {
        inherit username;
        homeDirectory =
          if pkgs.stdenv.hostPlatform.isLinux then "/home/${username}" else "/Users/${username}";
        stateVersion = homeStateVersion;
        sessionVariables.NIX_PATH = "nixpkgs=${pkgs.path}";
      };
      lib.own.mkConfigOnly =
        appName:
        lib.mkDefault (
          if options.programs.${appName}.package.type.check null then null else pkgs.emptyDirectory
        );
    }
    (lib.mkIf (osConfig == null) { # Not NixOS
      targets.genericLinux.enable = pkgs.stdenv.hostPlatform.isLinux;
      nix.gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 7d";
      };
    })
  ];
}
