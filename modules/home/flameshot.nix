{
  flake.modules.homeManager.flameshot =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
      options.flameshotPkg = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        default = [ pkgs.flameshot ];
      };

      config = {
        home.packages = config.flameshotPkg;

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
