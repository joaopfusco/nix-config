{
  flake.modules.nixos.user =
    { config, pkgs, ... }:
    {
      programs.${config.host.shell.name}.enable = true;
      users.users.${config.host.user.name} = {
        shell = pkgs.${config.host.shell.name};
        isNormalUser = true;
        description = "Joao Pedro Fusco";
        extraGroups = [
          "networkmanager"
          "wheel"
          "docker"
          "libvirtd"
          "kvm"
          "dialout"
        ];
      };
    };
}
