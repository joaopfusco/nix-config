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
      home.homeDirectory =
        if pkgs.stdenv.hostPlatform.isLinux then
          "/home/${config.host.user.name}"
        else
          "/Users/${config.host.user.name}";

      home.sessionVariables.NIX_PATH = "nixpkgs=${pkgs.path}";

      programs.home-manager.enable = true;
    };
}
