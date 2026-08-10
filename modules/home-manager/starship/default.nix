{
  flake.modules.homeManager.starship =
    { config, ... }:
    {
      programs.starship = {
        enable = true;
        enableZshIntegration = true;
      };

      xdg.configFile."starship.toml".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-config/modules/programs/starship/starship.toml";
    };
}
