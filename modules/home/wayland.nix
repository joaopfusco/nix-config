{
  flake.modules.homeManager.wayland = {
    home.sessionVariables = {
      MOZ_ENABLE_WAYLAND = "1";
      ELECTRON_OZONE_PLATFORM_HINT = "wayland";
    };

    xdg.configFile."chrome-flags.conf".text = "--ozone-platform-hint=wayland\n";
  };
}
