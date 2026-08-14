{
  flake.modules.darwin.user =
    { config, ... }:
    {
      system.primaryUser = config.host.user.name;
      programs.zsh.enable = true;
      users.users.${config.host.user.name} = {
        home = "/Users/${config.host.user.name}";
        # shell = pkgs.zsh;
      };
    };
}
