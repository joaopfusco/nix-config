{ inputs, config, ... }:
let
  overlays = builtins.attrValues config.flake.overlays;
in
{
  flake.modules.nixos.base = {
    _module.args.inputs = inputs;
    imports = [ inputs.home-manager.nixosModules.home-manager ];
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = "backup";
    };
    nixpkgs.config.allowUnfree = true;
    nixpkgs.overlays = overlays;
  };

  flake.modules.homeManager.base =
    {
      config,
      pkgs,
      ...
    }:
    {
      _module.args.inputs = inputs;
      nix.registry.pkgs.flake = inputs.self;

      news.display = "silent";

      home.username = config.host.user.name;
      home.homeDirectory = config.host.homeDir;

      home.sessionVariables.NIX_PATH = "nixpkgs=${pkgs.path}";
      home.sessionVariables.NH_FLAKE = config.host.configDir;

      programs.home-manager.enable = true;
    };
}
