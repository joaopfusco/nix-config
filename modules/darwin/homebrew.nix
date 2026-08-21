{
  flake.modules.darwin.homebrew = {
    homebrew = {
      enable = true;
      onActivation = {
        autoUpdate = false;
        upgrade = false;
        cleanup = "uninstall";
      };
      taps = [ ];
      brews = [
        "mas"
      ];
      casks = [
        "libreoffice"
        "vlc"
        "obs"
        "google-chrome"
        "kitty"
        "postman"
        "dbeaver-community"
        "visual-studio-code"
        "zed"
        "orbstack"
        "maccy"
      ];
      masApps = { };
    };
  };
}
