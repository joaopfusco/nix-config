{
  flake.modules.darwin.desktop = {
    # power
    power.sleep.display = 15; # minutes

    # macOS defaults
    system.defaults = {
      dock = {
        autohide = true;
        show-recents = false;
        mru-spaces = false;
        wvous-tl-corner = 2; # Mission Control
      };
      finder = {
        AppleShowAllExtensions = true;
        FXPreferredViewStyle = "Nlsv";
      };
      trackpad = {
        Clicking = true;
        TrackpadThreeFingerDrag = true;
      };
      NSGlobalDomain = {
        AppleICUForce24HourTime = true;
        AppleInterfaceStyle = "Dark";
        KeyRepeat = 2;
      };
      screensaver = {
        askForPassword = true;
        askForPasswordDelay = 0;
      };
      menuExtraClock = {
        ShowDate = 1; # Always
      };
    };

    # keybindings
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
