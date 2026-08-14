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
        nixLd
        inotify
        systemdBoot
        gnome
        aliases
        pkgs
        mediaCodecs
        flatpak
        docker
        vm
      ])
      ++ [
        ./_hardware.nix
        "${inputs.nixos-hardware}/common/cpu/intel/coffee-lake"
        "${inputs.nixos-hardware}/common/gpu/nvidia/turing"
        "${inputs.nixos-hardware}/common/gpu/nvidia/prime.nix"
        "${inputs.nixos-hardware}/common/pc/laptop"
        "${inputs.nixos-hardware}/common/pc/ssd"
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

            # intel
            services.thermald.enable = true;

            # nvidia
            services.xserver.videoDrivers = [
              "modesetting"
              "nvidia"
            ];
            hardware.nvidia = {
              nvidiaSettings = true;
              modesetting.enable = true;
              powerManagement.enable = true;
              package = config.boot.kernelPackages.nvidiaPackages.stable;

              # PCI bus IDs `lspci -nn | grep -E "VGA|3D"`:
              #   00:02.0 Intel UHD Graphics 630   -> PCI:0:2:0
              #   01:00.0 NVIDIA Quadro RTX 3000   -> PCI:1:0:0
              prime = {
                intelBusId = "PCI:0:2:0";
                nvidiaBusId = "PCI:1:0:0";
                # PRIME offload (render on iGPU, dGPU idle unless invoked via
                # `nvidia-offload <cmd>`) is already forced true by nixos-hardware's
                # common/gpu/nvidia/prime.nix — not redeclared here.
              };
            };

            # CDI (Container Device Interface) GPU passthrough for docker/podman —
            # `docker run --device nvidia.com/gpu=all ...` or `--gpus all`.
            hardware.nvidia-container-toolkit.enable = true;
          }
        )
      ];
  };
}
