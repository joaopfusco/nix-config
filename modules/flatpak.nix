{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.myflatpak;
  flatpakBin = "/usr/bin/flatpak";

  remoteCmds = concatStringsSep "\n" (map (remote: 
    "${flatpakBin} remote-add --user --if-not-exists ${remote.name} ${remote.location}"
  ) cfg.remotes);

  appList = concatStringsSep " " cfg.packages;

in {
  options.services.myflatpak = {
    enable = mkEnableOption "Declarative management of Flatpak";
    
    remotes = mkOption {
      type = types.listOf (types.submodule {
        options = {
          name = mkOption { type = types.str; };
          location = mkOption { type = types.str; };
        };
      });
      default = [];
    };

    packages = mkOption {
      type = types.listOf types.str;
      default = [];
    };

    update.auto.enable = mkOption {
      type = types.bool;
      default = true;
      description = "If true, runs flatpak update during the switch.";
    };
    
    uninstallUnmanaged = mkOption {
      type = types.bool;
      default = false;
      description = "If true, removes installed apps that are not in the list.";
    };
  };

  config = mkIf cfg.enable {
    home.activation.manageFlatpaks = hm.dag.entryAfter ["writeBoundary"] ''
      export PATH=$PATH:/usr/bin:/bin
      
      # 1. Remotes configration
      ${remoteCmds}

      # 2. Install/Sync Packages
      if [ -n "${appList}" ]; then
        echo "Installing/syncing packages from the list..."
        ${flatpakBin} install --user -y flathub ${appList}
      fi

      # 3. Declarative uninstallation (Purge)
      ${optionalString cfg.uninstallUnmanaged ''
        echo "Removing unmanaged packages..."
        installed_apps=$(${flatpakBin} list --user --app --columns=application)
        for app in $installed_apps; do
          if [[ ! " ${appList} " =~ " $app " ]]; then
            ${flatpakBin} uninstall --user -y "$app"
          fi
        done
      ''}

      # 4. Automatic Update
      ${optionalString cfg.update.auto.enable ''
        echo "Updating installed packages..."
        ${flatpakBin} update --user -y
      ''}

      # 5. Cleanup
      ${flatpakBin} uninstall --user --unused -y
    '';
  };
}