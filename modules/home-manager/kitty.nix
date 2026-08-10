{
  flake.modules.homeManager.kitty =
    { pkgs, ... }:
    {
      programs.kitty = {
        enable = true;
        package = pkgs.kitty;
        themeFile = "tokyo_night_night";

        settings = {
          shell = "${pkgs.zsh}/bin/zsh --login";
          shell_integration = "enabled";

          window_padding_width = 4;

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
      };
    };
}
