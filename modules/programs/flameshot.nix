{
  flake.modules.homeManager.flameshot =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [ flameshot ];

      # sh -c "flameshot gui -p ~/Pictures/Screenshots -c"
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
}
