{
  flake.modules.homeManager.cinnamon =
    { lib, ... }:
    {
      dconf.settings = {
        # Appearance
        "org/cinnamon/desktop/interface" = {
          clock-show-date = true;
        };

        "org/cinnamon" = {
          hotcorner-layout = [
            "expo:true:0"
            "scale:false:0"
            "scale:false:0"
            "desktop:false:0"
          ];
        };

        # Power & session
        "org/cinnamon/settings-daemon/plugins/color" = {
          night-light-enabled = true;
          night-light-schedule-mode = "manual";
          night-light-temperature = lib.hm.gvariant.mkUint32 2700;
        };

        "org/cinnamon/settings-daemon/plugins/power" = {
          button-power = "suspend";
          sleep-inactive-ac-type = "nothing";
          sleep-inactive-battery-type = "suspend";
        };

        "org/cinnamon/desktop/session" = {
          idle-delay = lib.hm.gvariant.mkUint32 900; # 15 minutos
        };

        "org/cinnamon/desktop/screensaver" = {
          show-notifications = false;
        };

        # Peripherals & sound
        "org/cinnamon/desktop/peripherals/touchpad" = {
          disable-while-typing = true;
        };

        "org/cinnamon/desktop/sound" = {
          event-sounds = false;
        };

        # Keybindings & shortcuts
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
