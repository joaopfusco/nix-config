{ lib, ... }:
let
  hostOptions = {
    options.host = {
      name = lib.mkOption {
        type = lib.types.str;
      };
      user.name = lib.mkOption {
        type = lib.types.str;
        default = "joaop";
      };
      stateVersion = {
        home = lib.mkOption { type = lib.types.str; };
        nixos = lib.mkOption { type = lib.types.str; };
      };
    };
  };
in
{
  flake.modules.nixos.base = hostOptions;
  flake.modules.homeManager.base = hostOptions;
}
