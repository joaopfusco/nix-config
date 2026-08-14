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

      # macOS defaults
      system.defaults = {
        dock = {
          autohide = true;
          show-recents = false;
          mru-spaces = false;
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
      };
    };
}
