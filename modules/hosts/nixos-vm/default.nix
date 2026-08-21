{
  inputs,
  nixos,
  homeManager,
  ...
}:
let
  hostName = baseNameOf ./.;
in
{
  flake.nixosConfigurations.${hostName} = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      nixos.${hostName}
      nixos.base
      nixos.user
      nixos.common
      nixos.pkgs
    ];
    specialArgs.homeManagerModules = [
      homeManager.base
      homeManager.gh
      homeManager.git
      homeManager.direnv
      homeManager.dotnet
      homeManager.pkgs
      homeManager.fonts
      homeManager.zsh
      homeManager.aliases
      homeManager.starship
      homeManager.opencode
      homeManager.claudeCode
    ];
  };

  flake.modules.nixos.${hostName} =
    { config, homeManagerModules, ... }:
    {
      imports = [
        ./_hardware.nix
      ];

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

      services.openssh = {
        enable = true;
        openFirewall = true;
      };
    };
}
