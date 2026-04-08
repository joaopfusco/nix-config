{ config, lib, pkgs, ... }:

{
  programs.kitty = {
    enable = true;
    
    settings = {
      shell = "${pkgs.zsh}/bin/zsh --login";

      window_padding_width = 10;
      remember_window_size = "no";
      initial_window_width = "1100";
      initial_window_height = "700";
      confirm_os_window_close = 0;

      font_size = "12.0";
      disable_ligatures = "never";

      scrollback_lines = 10000;
      enable_audio_bell = false;
      update_check_interval = 0;
      
      background_opacity = "1.0";
    };
    
    themeFile = "Dracula";
  };
}