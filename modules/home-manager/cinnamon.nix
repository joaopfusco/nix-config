{
  flake.modules.homeManager.cinnamon =
    { lib, ... }:
    let
      wallpaper = ./wallpapers/jesus-crown.jpg;
    in
    {
      dconf.settings = {
        "org/gnome/desktop/interface" = {
          clock-show-seconds = false;
          clock-show-weekday = true;
          color-scheme = "prefer-dark";
          show-battery-percentage = true;
          icon-theme = "Papirus-Dark";
          gtk-theme = "Mint-Y-Dark";
        };

        "org/gnome/desktop/peripherals/touchpad" = {
          disable-while-typing = true;
          two-finger-scrolling-enabled = true;
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

        "org/gnome/settings-daemon/plugins/color" = {
          night-light-enabled = true;
          night-light-schedule-automatic = false;
          night-light-temperature = lib.hm.gvariant.mkUint32 2700;
        };

        "org/cinnamon/desktop/interface" = {
          icon-theme = "Papirus-Dark";
        };

        "org/cinnamon/desktop/background" = {
          picture-options = "zoom";
          picture-uri = "file://${wallpaper}";
        };

        "org/cinnamon/desktop/wm/preferences" = {
          button-layout = "appmenu:minimize,maximize,close";
          focus-mode = "click";
        };

        "org/cinnamon/desktop/session" = {
          idle-delay = lib.hm.gvariant.mkUint32 900; # 15 minutos
        };

        "org/cinnamon/desktop/notifications" = {
          show-in-lock-screen = false;
        };

        "org/cinnamon/desktop/screensaver" = {
          lock-enabled = true;
          idle-activation-enabled = true;
        };

        "org/cinnamon/screensaver" = {
          lock-delay = lib.hm.gvariant.mkUint32 0;
        };

        "org/cinnamon/settings-daemon/plugins/power" = {
          lock-on-suspend = true;
        };

        "org/cinnamon" = {
          overview-corner-hover = true;
          theme = "Mint-Y-Dark";
        };

        "org/cinnamon/desktop/keybindings" = {
          custom-list = [
            "custom0"
            "custom1"
            "custom2"
            "custom3"
            "custom4"
          ];
        };

        "org/cinnamon/desktop/keybindings/custom-keybindings/custom0" = {
          name = "Files";
          binding = [ "<Super>e" ];
          command = "nemo";
        };

        "org/cinnamon/desktop/keybindings/custom-keybindings/custom1" = {
          name = "Settings";
          binding = [ "<Super>i" ];
          command = "cinnamon-settings";
        };

        "org/cinnamon/desktop/keybindings/custom-keybindings/custom2" = {
          name = "Terminal";
          binding = [ "<Super>Return" ];
          command = "kitty";
        };

        "org/cinnamon/desktop/keybindings/custom-keybindings/custom3" = {
          name = "CopyQ";
          binding = [ "<Super>v" ];
          command = "copyq toggle";
        };

        "org/cinnamon/desktop/keybindings/custom-keybindings/custom4" = {
          name = "Flameshot";
          binding = [ "<Super><Shift>p" ];
          command = ''sh -c "flameshot gui -p ~/Pictures/Screenshots -c"'';
        };
      };
    };
}
