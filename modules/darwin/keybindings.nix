{
  flake.modules.darwin.keybindings = {
    services.skhd = {
      enable = true;
      skhdConfig = ''
        cmd - e : open -a Finder
        cmd - i : open -a "System Settings"
        cmd - return : open -a kitty
      '';
    };
  };
}
