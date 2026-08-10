{
  flake.modules.homeManager.zedEditor =
    { config, ... }:
    {
      programs.zed-editor.enable = true;

      xdg.configFile."zed/settings.json".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-config/modules/programs/zed-editor/settings.json";
      xdg.configFile."zed/keymap.json".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-config/modules/programs/zed-editor/keymap.json";
    };
}
