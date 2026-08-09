{
  flake.modules.homeManager.distroboxExport =
    { config, lib, ... }:
    let
      scriptPath = "${config.home.homeDirectory}/.local/bin/sync-exports.sh";
    in
    {
      home.file.".local/bin/sync-exports.sh" = {
        source = ./sync-exports.sh;
        executable = true;
      };

      home.activation.exportToDistrobox = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        DRY_RUN_CMD="$DRY_RUN_CMD" ${scriptPath}
      '';

      systemd.user.paths.distrobox-export-sync = {
        Unit.Description = "Watch ~/.nix-profile/bin for distrobox-export sync";
        Path.PathChanged = "%h/.nix-profile/bin";
        Install.WantedBy = [ "default.target" ];
      };

      systemd.user.services.distrobox-export-sync = {
        Unit.Description = "Sync ~/.nix-profile/bin into distrobox-export";
        Service = {
          Type = "oneshot";
          ExecStart = scriptPath;
        };
      };
    };
}
