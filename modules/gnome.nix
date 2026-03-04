{ config, pkgs, lib, ... }:

{
  options.features.gnome.enable = lib.mkEnableOption "Configurações e Extensões do GNOME";

  config = lib.mkIf config.features.gnome.enable {
    gtk = {
      enable = true;
      iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.papirus-icon-theme;
      };
    };

    home.packages = with pkgs; [
      gnome-tweaks
      gnome-extension-manager
      gnomeExtensions.clipboard-indicator
      gnomeExtensions.appindicator
    ];

    dconf.settings = {
      "org/gnome/shell" = {
        disable-user-extensions = false;
        enabled-extensions = [
          "clipboard-indicator@tudmotu.com"
          "appindicatorsupport@rgcjonas.gmail.com"
        ];
      };

      "org/gnome/desktop/wm/preferences" = {
        button-layout = "appmenu:minimize,maximize,close";
      };

      "org/gnome/desktop/background" = {
        picture-uri = "file://${./wallpapers/crown.jpg}";
        picture-uri-dark = "file://${./wallpapers/crown.jpg}";
      };

      "org/gnome/desktop/screensaver" = {
        picture-uri = "file://${./wallpapers/crown.jpg}";
      };

      "org/gnome/shell/extensions/clipboard-indicator" = {
        history-size = 50;
        display-mode = 0;
        preview-size = 30;
        move-item-first = true;
        paste-on-selection = true;
      };

      "org/gnome/settings-daemon/plugins/media-keys" = {
        custom-keybindings = [
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/"
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/"
        ];
      };

      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
        binding = "<Super>t";
        command = "alacritty";
        name = "Open Alacritty Terminal";
      };

      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
        binding = "<Super>e";
        command = "nautilus";
        name = "Open Nautilus File Manager";
      };

      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2" = {
        binding = "<Super>i";
        command = "gnome-control-center";
        name = "Open GNOME Control Center";
      };

      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3" = {
        binding = "<Super>c";
        command = "code --new-window /home/joaop/nixos-config/";
        name = "Open NixOS Config";
      };
    };
  };
}