{ lib, ... }:
let
  hostOptions = {
    name = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Nome do host/perfil.";
    };
    user.name = lib.mkOption {
      type = lib.types.str;
      default = "joaop";
      description = "Usuário dono da configuração.";
    };
    system = lib.mkOption {
      type = lib.types.str;
      default = "x86_64-linux";
      description = "Arquitetura do sistema.";
    };
    state.version = lib.mkOption {
      type = lib.types.str;
      default = "26.05";
      description = "stateVersion do NixOS/Home Manager.";
    };
    isNixOS = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
    isHomeManager = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };
in
{
  flake.modules.nixos.base =
    { config, ... }:
    {
      options.host = hostOptions;
      config = {
        host.isNixOS = lib.mkDefault true;
        system.stateVersion = config.host.state.version;
      };
    };

  flake.modules.homeManager.base = {
    options.host = hostOptions;
    config.host.isHomeManager = lib.mkDefault true;
  };
}
