{ inputs, ... }:
{
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
