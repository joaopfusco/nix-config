{ pkgs, ... }:

{
  # System packages (CLI utilities at system level)
  environment.systemPackages = with pkgs; [
    wget
    curl
  ];

  # Fonts
  fonts.packages = [
    pkgs.nerd-fonts.jetbrains-mono
  ];

  # Homebrew
  homebrew = {
    enable = true; # Requires Homebrew to be installed

    onActivation = {
      autoUpdate = true;
      cleanup = "zap"; # Removes anything not declared here
      upgrade = true;
    };

    taps = [ ];

    brews = [
      "mas"
    ];

    # GUI applications (Casks)
    casks = [
      "google-chrome"
      "visual-studio-code"
      "vlc"
      "libreoffice"
      "obs"
      "dbeaver-community"
      "postman"
      "kitty"
      "zed"
      "orbstack"

      # Optional
      # "rectangle"  # Tiling-like window management
      # "raycast"    # Spotlight replacement (Alfred-like)
      # "maccy"      # Clipboard manager (similar to GNOME's clipboard-indicator)
    ];

    # Mac App Store
    masApps = {
      # Find IDs with: mas search "App Name"
      # Example: "Xcode" = 497799835;
    };
  };
}
