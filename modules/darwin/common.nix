{
  flake.modules.darwin.common =
    { pkgs, ... }:
    {
      # nix
      nix = {
        enable = true;
        package = pkgs.nix;
        settings.experimental-features = [
          "nix-command"
          "flakes"
        ];
        optimise.automatic = true;
        gc = {
          automatic = true;
          interval = {
            Weekday = 0;
            Hour = 3;
            Minute = 0;
          };
          options = "--delete-older-than 7d";
        };
      };

      # locale
      time.timeZone = "America/Sao_Paulo";

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
