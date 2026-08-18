{
  flake.modules.homeManager.cinnamon =
    { lib, ... }:
    {
      dconf.settings = {
        "org/cinnamon/desktop/interface" = {
          gtk-theme = "Mint-Y-Dark";
          icon-theme = "Papirus-Dark";
        };

        "org/cinnamon/desktop/peripherals/touchpad" = {
          disable-while-typing = true;
        };

        "org/cinnamon/desktop/sound" = {
          event-sounds = false;
        };

        "org/cinnamon/settings-daemon/plugins/color" = {
          night-light-enabled = true;
          night-light-schedule-mode = "manual";
          night-light-temperature = lib.hm.gvariant.mkUint32 2700;
        };

        "org/cinnamon/desktop/wm/preferences" = {
          focus-mode = "click";
          theme = "Mint-Y-Dark";
        };

        "org/cinnamon/desktop/session" = {
          idle-delay = lib.hm.gvariant.mkUint32 900; # 15 minutos
        };

        "org/cinnamon/theme" = {
          name = "Mint-Y-Dark";
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
