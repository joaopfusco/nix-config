{ lib, ... }:
let
  username = "joaop";
  hostOptions =
    { config, pkgs, ... }:
    {
      options.host = {
        name = lib.mkOption {
          type = lib.types.str;
        };
        user.name = lib.mkOption {
          type = lib.types.str;
          default = username;
        };
        homeDir = lib.mkOption {
          type = lib.types.str;
          default =
            if pkgs.stdenv.hostPlatform.isLinux then
              "/home/${config.host.user.name}"
            else
              "/Users/${config.host.user.name}";
        };
        configDir = lib.mkOption {
          type = lib.types.str;
          default = "${config.host.homeDir}/nix-config";
        };
      };
    };
in
{
  flake.lib.username = username;
  flake.modules.nixos.base = hostOptions;
  flake.modules.homeManager.base = hostOptions;
}
