{ config, pkgs, lib, ... }:

{
  options.features.gnome.enable = lib.mkEnableOption "Configurações e Extensões do GNOME";

  config = lib.mkIf config.features.gnome.enable {
    home.packages = with pkgs; [
      gnomeExtensions.blur-my-shell
      gnomeExtensions.clipboard-indicator
    ];

    dconf.settings = {
      "org/gnome/shell" = {
        disable-user-extensions = false;
        enabled-extensions = [
          "blur-my-shell@aunetx"
          "clipboard-indicator@tudmotu.com"
        ];
      };

      "org/gnome/shell/extensions/clipboard-indicator" = {
        history-size = 30;
        display-mode = 0;
        preview-size = 30;
      };
    };
  };
}