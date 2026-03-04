{ config, pkgs, lib, ... }:

{
  options.features.cinnamon.enable = lib.mkEnableOption "Configurações do Cinnamon";

  config = lib.mkIf config.features.cinnamon.enable {
    home.packages = with pkgs; [
      dconf-editor
      diodon
    ];

    dconf.settings = {
      "org/cinnamon/desktop/wm/preferences" = {
        button-layout = "menu:minimize,maximize,close";
      };

      "org/cinnamon/desktop/background" = {
        picture-uri = "file://${./wallpapers/crown.jpg}";
      };

      "org/cinnamon/desktop/screensaver" = {
        picture-uri = "file://${./wallpapers/crown.jpg}";
      };

      "org/cinnamon/desktop/keybindings" = {
        custom-list = [ "custom0" "custom1" "custom2" "custom3" "custom4" ];
      };

      "org/cinnamon/desktop/keybindings/custom-keybindings/custom0" = {
        binding = [ "<Super>t" ];
        command = "alacritty";
        name = "Open Alacritty Terminal";
      };

      "org/cinnamon/desktop/keybindings/custom-keybindings/custom1" = {
        binding = [ "<Super>e" ];
        command = "nemo";
        name = "Open Nemo File Manager";
      };

      "org/cinnamon/desktop/keybindings/custom-keybindings/custom2" = {
        binding = [ "<Super>i" ];
        command = "cinnamon-settings";
        name = "Open Cinnamon Settings";
      };

      "org/cinnamon/desktop/keybindings/custom-keybindings/custom3" = {
        binding = [ "<Super>c" ];
        command = "code --new-window /home/joaop/nix-config/";
        name = "Open Nix Config";
      };

      "org/cinnamon/desktop/keybindings/custom-keybindings/custom4" = {
        binding = [ "<Super>j" ];
        command = "diodon";
        name = "Open Diodon History";
      };
    };
  };
}