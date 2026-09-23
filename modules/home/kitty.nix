{
  flake.modules.homeManager.kitty =
    { pkgs, config, ... }:
    {
      programs.kitty = {
        enable = true;
        themeFile = "tokyo_night_night";
        font = {
          name = "JetBrainsMono Nerd Font Mono";
          size = 12;
          package = pkgs.nerd-fonts.jetbrains-mono;
        };
        settings = {
          shell = config.host.shell.path;
          shell_integration = "enabled";
          background_opacity = 1.0;
          window_padding_width = 4;
          initial_window_width = "145c";
          initial_window_height = "40c";
          remember_window_size = "no";
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
          remember_window_position = "yes";
          macos_quit_when_last_window_closed = "yes";
          paste_actions = "quote-urls-at-prompt";
        };
        environment.LC_ALL = "en_US.UTF-8";
        keybindings = {
          "ctrl+shift+left" = "neighboring_window left";
          "ctrl+shift+right" = "neighboring_window right";
          "ctrl+shift+up" = "neighboring_window up";
          "ctrl+shift+down" = "neighboring_window down";
        };
      };
    };
}
