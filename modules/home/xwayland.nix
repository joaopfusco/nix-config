{
  flake.modules.homeManager.xwayland = {
    xdg.configFile."chrome-flags.conf".text = "--ozone-platform-hint=x11\n";
  };
}
