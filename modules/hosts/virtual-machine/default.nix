{ config, inputs, ... }:
{
  flake.nixosConfigurations."virtual-machine" = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs.homeManagerModules = with config.flake.modules.homeManager; [
      base
      gh
      git
      direnv
      nodejs
      python
      dotnet
      pkgs
      zsh
      aliases
      starship
      claudeCode
      zedEditor
      kitty
      dconf
    ];
    modules =
      (with config.flake.modules.nixos; [
        base
        user
        common
        nixLd
        inotify
        grub
        intel
        nvidia
        gnome
        pkgs
        mediaCodecs
        flatpak
        docker
        vm
      ])
      ++ [
        ./_hardware.nix
        (
          { config, homeManagerModules, ... }:
          {
            host.name = "virtual-machine";
            host.stateVersion.nixos = "26.05";

            home-manager = {
              sharedModules = homeManagerModules;
              users.${config.host.user.name} = {
                host.name = "virtual-machine";
                host.stateVersion.home = "26.05";
              };
            };
          }
        )
      ];
  };
}
