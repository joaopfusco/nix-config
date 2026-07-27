{ config, ... }:
{
  programs.zed-editor = {
    enable = true;
    package = config.lib.own.mkConfigOnly "zed-editor";
  };

  xdg.configFile."zed/settings.json".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-config/modules/zed-editor/config/settings.json";
  xdg.configFile."zed/keymap.json".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-config/modules/zed-editor/config/keymap.json";
}
