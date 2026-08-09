{
  flake.modules.nixos.nvidia = {
    hardware.nvidia = {
      nvidiaSettings = true;
      modesetting.enable = true;

      # PCI bus IDs confirmados via `lspci -nn | grep -E "VGA|3D"` no precision-7540:
      #   00:02.0 Intel UHD Graphics 630   -> PCI:0:2:0
      #   01:00.0 NVIDIA Quadro RTX 3000   -> PCI:1:0:0
      prime = {
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };
  };
}
