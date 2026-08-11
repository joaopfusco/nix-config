{
  flake.modules.nixos.distrobox =
    { pkgs, config, ... }:
    {
      environment.systemPackages = [ pkgs.distrobox ];
      systemd.services.distrobox-ubuntu = {
        description = "Ensure ubuntu distrobox container exists";
        wantedBy = [ "multi-user.target" ];
        after = [ "docker.service" ];
        requires = [ "docker.service" ];
        path = [ config.virtualisation.docker.package ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          User = config.host.user.name;
          ExecStart = ''
            ${pkgs.distrobox}/bin/distrobox create \
              --name ubuntu \
              --image docker.io/library/ubuntu:latest \
              --init \
              --nvidia \
              --additional-packages "systemd libpam-systemd pipewire-audio-client-libraries" \
              --yes
          '';
        };
      };
    };
}
