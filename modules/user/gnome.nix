{ config, pkgs, lib, ... }:

{
  gtk = {
    enable = true;
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
  };

  home.packages = with pkgs; [
    papirus-icon-theme
    gnome-tweaks
    gnome-extension-manager
    gnomeExtensions.clipboard-indicator
    gnomeExtensions.appindicator
    gnomeExtensions.dash-to-dock
  ];

  dconf.settings = {
    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = [
        "clipboard-indicator@tudmotu.com"
        "appindicatorsupport@rgcjonas.gmail.com"
        "dash-to-dock@micxgx.gmail.com"
      ];
    };

    "org/gnome/desktop/background" = {
      picture-uri = "file://${../../wallpaper/jesus-crown.jpg}";
      picture-uri-dark = "file://${../../wallpaper/jesus-crown.jpg}";
    };
    "org/gnome/desktop/screensaver" = {
      picture-uri = "file://${../../wallpaper/jesus-crown.jpg}";
    };

    "org/gnome/desktop/wm/preferences" = {
      button-layout = "appmenu:minimize,maximize,close";
    };

    "org/gnome/desktop/wm/keybindings" = {
      switch-windows = [ "<Alt>Tab" ];
      switch-windows-backward = [ "<Shift><Alt>Tab" ];
      switch-applications = [ "<Super>Tab" ];
      switch-applications-backward = [ "<Shift><Super>Tab" ];
    };

    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/"
      ];
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding = "<Super>t";
      command = "kgx";
      name = "Terminal";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
      binding = "<Super>e";
      command = "nautilus";
      name = "Files";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2" = {
      binding = "<Super>i";
      command = "gnome-control-center";
      name = "Settings";
    };
  };
}