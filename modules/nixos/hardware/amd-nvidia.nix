{ config, ... }:

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
      offload = {
        enable = true;
        enableOffloadCmd = true; # nvidia-offload <nome-do-programa> to use nvidia
      };

      # Run 'nix-shell -p lshw --run "sudo lshw -c display"'.
      amdgpuBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };
}
