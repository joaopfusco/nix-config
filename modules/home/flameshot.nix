{
  flake.modules.homeManager.flameshot =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
      options.flameshot.installPackage = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Install the flameshot package (disable if it's provided some other way).
          Capture with `flameshot gui -p ~/Pictures/Screenshots -c`.
        '';
      };

      config = {
        home.packages = lib.optional config.flameshot.installPackage pkgs.flameshot;

        xdg.configFile."flameshot/flameshot.ini".source = (pkgs.formats.ini { }).generate "flameshot.ini" {
          General = {
            contrastOpacity = 188;
            showHelp = false;
            showStartupLaunchMessage = false;
          };
        };

        systemd.user.services.flameshot = {
          Unit = {
            Description = "Flameshot screenshot tool";
            After = [ "graphical-session.target" ];
            PartOf = [ "graphical-session.target" ];
          };

          Service = {
            ExecStart = "flameshot";
            Restart = "on-failure";
          };

          Install.WantedBy = [ "graphical-session.target" ];
        };
      };
    };
}
