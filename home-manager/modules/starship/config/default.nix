{ config, ... }:
{
  xdg.configFile."starship.toml".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-config/home-manager/modules/starship/config/starship.toml";
}
