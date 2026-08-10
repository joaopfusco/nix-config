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
      cliPkgs
      zsh
      starship
      claudeCode
      zedEditor
      kitty
    ];
    modules = (with config.flake.modules.nixos; [
      base
      user
      networking
      locale
      inotify
      grub
      hardwareCommon
      intel
      nvidia
      audio
      gnome
      cliPkgs
      guiPkgs
      mediaCodecs
      flatpak
      distrobox
      docker
      vm
    ]) ++ [
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
