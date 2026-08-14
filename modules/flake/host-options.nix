{ lib, ... }:
let
  username = "joaop";
  hostOptions = {
    options.host = {
      name = lib.mkOption {
        type = lib.types.str;
      };
      user.name = lib.mkOption {
        type = lib.types.str;
        default = username;
      };
    };
  };
in
{
  flake.modules.nixos.base = hostOptions;
  flake.modules.darwin.base = hostOptions;
  flake.modules.homeManager.base = hostOptions;
  flake.lib.username = username;
}
