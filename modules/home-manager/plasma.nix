{ inputs, ... }:
{
  flake.modules.homeManager.plasma = {
    imports = [ inputs.plasma-manager.homeModules.plasma-manager ];

    programs.plasma = {
      enable = true;

      workspace = {
        lookAndFeel = "org.kde.breezedark.desktop";
        wallpaper = ./wallpapers/jesus-crown.jpg;
        wallpaperFillMode = "preserveAspectCrop";
      };

      input.keyboard.layouts = [
        {
          layout = "us";
          variant = "intl";
        }
      ];

      kscreenlocker = {
        autoLock = true;
        lockOnResume = true;
        timeout = 15;
      };

      kwin.nightLight = {
        enable = true;
        mode = "constant";
        temperature = {
          day = 2700;
          night = 2700;
        };
      };

      hotkeys.commands = {
        "Terminal" = {
          key = "Meta+Return";
          command = "kitty";
        };
      };

      # Painel padrão do Plasma, só com o ícone do launcher trocado e os
      # apps centralizados (2 spacers), mesmos favoritos do gnome.nix.
      panels = [
        {
          location = "bottom";
          widgets = [
            {
              kickoff = {
                icon = "nix-snowflake-white";
              };
            }
            {
              panelSpacer.expanding = true;
            }
            {
              iconTasks = {
                launchers = [
                  "applications:google-chrome.desktop"
                  "applications:org.kde.dolphin.desktop"
                  "applications:org.kde.discover.desktop"
                  "applications:org.kde.systemsettings.desktop"
                  "applications:kitty.desktop"
                  "applications:dev.zed.Zed.desktop"
                  "applications:code.desktop"
                ];
              };
            }
            {
              panelSpacer.expanding = true;
            }
            "org.kde.plasma.systemtray"
            {
              digitalClock = { };
            }
          ];
        }
      ];

      configFile = {
        kdeglobals.General.TerminalApplication = "kitty";
        kdeglobals.General.TerminalService = "kitty.desktop";

        krunnerrc.General.FreeFloating = true;

        kwinrc.Desktops.Number = 2;

        spectaclerc.General.autoSaveImage = true;
        spectaclerc.General.clipboardGroup = "PostScreenshotCopyImage";
      };
    };
  };
}
