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
        tilesize = 48;
        minimize-to-application = true;
      };
      finder = {
        AppleShowAllExtensions = true;
        FXPreferredViewStyle = "Nlsv";
        ShowPathbar = true;
        ShowStatusBar = true;
        FXDefaultSearchScope = "SCcf"; # search current folder
        _FXShowPosixPathInTitle = true;
      };
      screencapture = {
        location = "~/Pictures/Screenshots";
        disable-shadow = true;
        type = "png";
      };
      loginwindow = {
        GuestEnabled = false;
      };
      trackpad = {
        Clicking = true;
        TrackpadThreeFingerDrag = true;
      };
      NSGlobalDomain = {
        AppleICUForce24HourTime = true;
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
  };
}
