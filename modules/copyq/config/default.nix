{ lib, ... }:
{
  # Super+V -> copyq toggle
  systemd.user.services.copyq = {
    Unit = {
      Description = "CopyQ clipboard management daemon";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };

    Service = {
      ExecStart = "copyq";
      Restart = "on-failure";
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
}

