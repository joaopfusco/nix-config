{ config, ... }:
{
  xdg.configFile."starship.toml".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-config/modules/home/starship/config/starship.toml";
}
