{ config, ... }:
{
  xdg.configFile."zed/settings.json".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-config/modules/zed/config/settings.json";
  xdg.configFile."zed/keymap.json".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-config/modules/zed/config/keymap.json";
}
