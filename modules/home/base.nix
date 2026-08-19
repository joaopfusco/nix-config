{ inputs, ... }:
{
  flake.modules.homeManager.base =
    {
      config,
      pkgs,
      ...
    }:
    {
      config = {
        _module.args.inputs = inputs;
        nix.registry.pkgs.flake = inputs.self;
        programs.home-manager.enable = true;
        news.display = "silent";
        home = {
          username = config.host.user.name;
          homeDirectory =
            if pkgs.stdenv.hostPlatform.isLinux then
              "/home/${config.host.user.name}"
            else
              "/Users/${config.host.user.name}";
          sessionVariables.NIX_PATH = "nixpkgs=${pkgs.path}";
        };
      };
    };
}
