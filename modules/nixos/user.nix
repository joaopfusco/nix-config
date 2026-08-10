{
  flake.modules.nixos.user =
    { config, pkgs, ... }:
    {
      programs.zsh.enable = true;
      users.users.${config.host.user.name} = {
        shell = pkgs.zsh;
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
