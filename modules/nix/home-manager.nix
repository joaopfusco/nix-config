{ inputs, ... }:
{
  flake.modules.homeManager.base =
    { config, lib, pkgs, osConfig, ... }:
    {
      config = lib.mkMerge [
        {
          nix.registry.pkgs.flake = inputs.self;
          news.display = "silent";
          home = {
            username = config.host.user.name;
            homeDirectory =
              if pkgs.stdenv.hostPlatform.isLinux then
                "/home/${config.host.user.name}"
              else
                "/Users/${config.host.user.name}";
            stateVersion = config.host.state.version;
            sessionVariables.NIX_PATH = "nixpkgs=${pkgs.path}";
          };
        }
        (lib.mkIf (osConfig == null) {
          targets.genericLinux.enable = pkgs.stdenv.hostPlatform.isLinux;
          nix.gc = {
            automatic = true;
            dates = "weekly";
            options = "--delete-older-than 7d";
          };
        })
      ];
    };
}
