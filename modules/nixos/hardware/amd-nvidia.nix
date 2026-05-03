{ ... }:

{
  imports = [
    ./nvidia.nix
  ];

  # NVIDIA GPU drivers
  services.switcherooControl.enable = true;
  hardware.nvidia = {
    # Enable power management features for NVIDIA GPUs, including fine-grained power management.
    powerManagement.finegrained = true;

    # Enable NVIDIA Prime for hybrid graphics setups (e.g., laptops with both integrated and discrete GPUs)
    prime = {
      # 1) Offload (current): Intel iGPU by default, NVIDIA on demand via 'nvidia-offload <prog>'.
      # Best for battery. May not work with external displays if HDMI/DP are wired to NVIDIA.
      offload = {
        enable = true;
        enableOffloadCmd = true; # nvidia-offload <nome-do-programa> to use nvidia
      };

      # 2) Reverse Sync: keeps offload behavior, but allows external displays through dGPU.
      #    Use this if external monitor doesn't work in pure offload mode.
      #    Disable 'offload' above before enabling this.
      # reverseSync.enable = true;

      # 3) Sync: NVIDIA always active, drives both internal and external displays.
      #    Simplest setup, but worst for battery.
      #    Disable 'offload' above before enabling this.
      # sync.enable = true;

      # Run 'nix-shell -p lshw --run "sudo lshw -c display"'.
      amdgpuBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };
}
