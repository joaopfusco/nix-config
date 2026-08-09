{ config, inputs, ... }:
{
  flake.nixosConfigurations.virtual-machine = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = { inherit inputs; };
    modules = [
      ./_hardware.nix
      { host.name = "virtual-machine"; }
      {
        nixpkgs.config.allowUnfree = true;
        nixpkgs.overlays = [ config.flake.overlays.default ];
      }
    ]
    ++ (with config.flake.modules.nixos; [
      base
      nixSettings
      nixLd
      networking
      locale
      user
      inotify
      grub
      hardwareCommon
      audio
      gnome
      mediaCodecs
      cliPkgs
      guiPkgs
      flatpak
      distrobox
      docker
      vmGuest
    ])
    ++ [
      {
        home-manager.users.${config.host.user.name}.imports = with config.flake.modules.homeManager; [
          base
          gh
          git
          direnv
          nodejs
          python
          dotnet
          cliTools
          zsh
          starship
          claudeCode
          zedEditor
          kitty
          flameshot
          copyq
        ];
      }
    ];
  };
}
