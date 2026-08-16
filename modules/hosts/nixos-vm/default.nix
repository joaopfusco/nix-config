{ config, inputs, ... }:
let
  hostName = baseNameOf ./.;
in
{
  flake.nixosConfigurations.${hostName} = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs.homeManagerModules = with config.flake.modules.homeManager; [
      base
      gh
      git
      direnv
      dotnet
      pkgs
      zsh
      aliases
      starship
      claudeCode
      zedEditor
      kitty
      gnome
    ];
    modules =
      (with config.flake.modules.nixos; [
        base
        user
        common
        gnome
        pkgs
      ])
      ++ [
        ./_hardware.nix
        (
          { config, homeManagerModules, ... }:
          {
            host.name = hostName;
            system.stateVersion = "26.05";

            home-manager = {
              sharedModules = homeManagerModules;
              users.${config.host.user.name} = {
                host.name = hostName;
                home.stateVersion = "26.05";
              };
            };

            boot.loader.grub.enable = true;
            boot.loader.grub.devices = [ "/dev/vda" ];
            boot.loader.grub.useOSProber = true;
          }
        )
      ];
  };
}
