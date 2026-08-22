{
  flake.modules.homeManager.gnome =
    { lib, ... }:
    {
      dconf.settings = {
        # Appearance
        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
          enable-hot-corners = true;
          show-battery-percentage = true;
        };

        "org/gnome/desktop/wm/preferences" = {
          button-layout = "appmenu:minimize,maximize,close";
          num-workspaces = 5;
        };

        "org/gnome/mutter" = {
          dynamic-workspaces = false;
        };

        # Power & session
        "org/gnome/settings-daemon/plugins/color" = {
          night-light-enabled = true;
          night-light-schedule-automatic = false;
          night-light-temperature = lib.hm.gvariant.mkUint32 2700;
        };

        "org/gnome/settings-daemon/plugins/power" = {
          power-button-action = "suspend";
          sleep-inactive-ac-type = "nothing";
          sleep-inactive-battery-type = "suspend";
        };

        "org/gnome/desktop/session" = {
          idle-delay = lib.hm.gvariant.mkUint32 900; # 15 minutes
        };

        "org/gnome/desktop/notifications" = {
          show-in-lock-screen = false;
        };

        # Peripherals & sound
        "org/gnome/desktop/peripherals/touchpad" = {
          disable-while-typing = true;
        };

        "org/gnome/desktop/sound" = {
          event-sounds = false;
        };

        # Keybindings & shortcuts
        "org/gnome/shell/keybindings" = {
          toggle-message-tray = [ "<Super>m" ];
        };

        "org/gnome/desktop/wm/keybindings" = {
          switch-applications = [ "<Super>Tab" ];
          switch-windows = [ "<Alt>Tab" ];
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

        # Extensions
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
      };
    };
}
