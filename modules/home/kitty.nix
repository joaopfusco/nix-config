{ pkgs, ... }:
let
  customKitty = if pkgs.stdenv.isDarwin then pkgs.emptyDirectory else pkgs.kitty;
in
{
  programs.kitty = {
    enable = true;
    package = customKitty;

    themeFile = "Catppuccin-Mocha";

    settings = {
      shell = "zsh --login";
      font_family = "JetBrainsMono Nerd Font";
      font_size = 12;

      # Window and Appearance
      window_padding_width = 10;
      confirm_os_window_close = 0;
      background_opacity = "1.00";

      # Cursor and Scroll
      cursor_shape = "beam";
      cursor_blink_interval = 0;
      scrollback_lines = 10000;
      enable_audio_bell = false;
      update_check_interval = 0;

      # Performance Wayland
      input_delay = 3;
      repaint_delay = 10;

      # Ligatures
      disable_ligatures = "never";
    };
  };
}
