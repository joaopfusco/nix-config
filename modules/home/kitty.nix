{
  flake.modules.homeManager.kitty =
    { pkgs, ... }:
    {
      programs.kitty = {
        enable = true;
        themeFile = "tokyo_night_night";
        font = {
          name = "JetBrainsMono Nerd Font";
          size = 12;
          package = pkgs.nerd-fonts.jetbrains-mono;
        };
        settings = {
          shell = "${pkgs.zsh}/bin/zsh --login";
          shell_integration = "enabled";
          background_opacity = 1.0;
          window_padding_width = 4;
          scrollbar = "always";
          scrollback_lines = 10000;
          confirm_os_window_close = 0;
          strip_trailing_spaces = "smart";
          cursor_shape = "beam";
          cursor_blink_interval = 0;
          enable_audio_bell = "no";
          update_check_interval = 0;
          disable_ligatures = "never";
          input_delay = 3;
          repaint_delay = 10;
        };
        keybindings = {
          "ctrl+shift+left" = "neighboring_window left";
          "ctrl+shift+right" = "neighboring_window right";
          "ctrl+shift+up" = "neighboring_window up";
          "ctrl+shift+down" = "neighboring_window down";
        };
      };
    };
}
