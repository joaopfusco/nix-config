{
  pkgs,
  host,
  username,
  ...
}:

{
  # Enable Flakes
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Set hostname
  networking.hostName = host;
  networking.localHostName = host;
  networking.computerName = host;

  # Primary user
  system.primaryUser = username;

  # Set time zone
  time.timeZone = "America/Sao_Paulo";

  # Touch ID for sudo
  security.pam.services.sudo_local.touchIdAuth = true;

  # Enable Zsh
  programs.zsh.enable = true;

  # Fonts
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  # macOS system defaults
  system.defaults = {
    # Dock
    dock = {
      autohide = true;
      mru-spaces = false;
      show-recents = false;
      tilesize = 48;
    };

    # Finder
    finder = {
      AppleShowAllExtensions = true;
      FXPreferredViewStyle = "Nlsv"; # List view
      ShowPathbar = true;
      ShowStatusBar = true;
    };

    # Global
    NSGlobalDomain = {
      AppleInterfaceStyle = "Dark";
      ApplePressAndHoldEnabled = false; # Allow key repeat
      InitialKeyRepeat = 14;
      KeyRepeat = 1;
    };

    # Trackpad
    trackpad = {
      Clicking = true; # Tap to click
      TrackpadThreeFingerDrag = true;
    };
  };

  # Automatically optimize the Nix store to save disk space
  nix.optimise.automatic = true;
  nix.gc = {
    automatic = true;
    interval = {
      Weekday = 0;
      Hour = 3;
      Minute = 0;
    }; # Sunday 3am
    options = "--delete-older-than 7d";
  };
}
