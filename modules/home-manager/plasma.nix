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
