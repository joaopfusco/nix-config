{
  flake.modules.homeManager.copyq =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
      options.copyq.installPackage = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Install the copyq package (disable if it's provided some other way).
          Toggle with `copyq toggle`.
        '';
      };

      config = {
        home.packages = lib.optional config.copyq.installPackage pkgs.copyq;

        systemd.user.services.copyq = {
          Unit = {
            Description = "CopyQ clipboard management daemon";
            After = [ "graphical-session.target" ];
            PartOf = [ "graphical-session.target" ];
          };

          Service = {
            ExecStart = if config.copyq.installPackage then lib.getExe pkgs.copyq else "copyq";
            Restart = "on-failure";
            Environment = "QT_QPA_PLATFORM=xcb";
          };

          Install.WantedBy = [ "graphical-session.target" ];
        };

        home.activation.copyqConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          if command -v copyq >/dev/null 2>&1; then
            run copyq config move true
            run copyq config activate_closes true
            run copyq config activate_focuses true
            run copyq config activate_pastes false
          fi
        '';
      };
    };
}
