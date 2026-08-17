{ homeManager, ... }:
{
  flake.modules.homeManager.gnome =
    { lib, ... }:
    {
      imports = [ homeManager.gtk ];
      dconf.settings = {
        "org/gnome/desktop/interface" = {
          clock-show-seconds = false;
          clock-show-weekday = true;
          color-scheme = "prefer-dark";
          enable-hot-corners = true;
          show-battery-percentage = true;
          icon-theme = "Papirus-Dark";
          gtk-theme = "WhiteSur-Dark";
          cursor-theme = "Bibata-Modern-Classic";
          cursor-size = 24;
          font-name = "JetBrainsMono Nerd Font 11";
          monospace-font-name = "JetBrainsMono Nerd Font 11";
        };

        "org/gnome/settings-daemon/plugins/color" = {
          night-light-enabled = true;
          night-light-schedule-automatic = false;
          night-light-temperature = lib.hm.gvariant.mkUint32 2700;
        };

        "org/gnome/desktop/peripherals/touchpad" = {
          disable-while-typing = true;
          two-finger-scrolling-enabled = true;
        };

        "org/gnome/desktop/wm/preferences" = {
          button-layout = "appmenu:minimize,maximize,close";
          focus-mode = "click";
        };

        "org/gnome/desktop/input-sources" = {
          sources = [
            (lib.hm.gvariant.mkTuple [
              "xkb"
              "us+intl"
            ])
          ];
        };

        "org/gnome/desktop/sound" = {
          event-sounds = false;
        };

        "org/gnome/desktop/session" = {
          idle-delay = lib.hm.gvariant.mkUint32 900; # 15 minutes
        };

        "org/gnome/desktop/screensaver" = {
          lock-enabled = true;
          lock-delay = lib.hm.gvariant.mkUint32 0;
          ubuntu-lock-on-suspend = true;
        };

        "org/gnome/desktop/notifications" = {
          show-in-lock-screen = false;
        };

        "org/gnome/shell/keybindings" = {
          toggle-message-tray = [ "<Super>m" ];
        };

        "org/gnome/shell/extensions/clipboard-indicator" = {
          history-size = 50;
          preview-size = 30;
          display-mode = 0;
          move-item-first = true;
          paste-on-selection = true;
          paste-on-select = false;
          case-sensitive-search = false;
          toggle-menu = [ "<Super>v" ];
        };

        "org/gnome/settings-daemon/plugins/media-keys" = {
          custom-keybindings = [
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/"
          ];
        };

        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
          name = "Files";
          binding = "<Super>e";
          command = "nautilus";
        };

        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
          name = "Settings";
          binding = "<Super>i";
          command = "gnome-control-center";
        };

        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2" = {
          name = "Terminal";
          binding = "<Super>Return";
          command = "kitty";
        };
      };
    };
}
