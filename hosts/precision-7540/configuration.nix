# Dell Precision 7540 — Intel Core i9-9980HK (Coffee Lake) + NVIDIA Quadro
# RTX 3000 Mobile / Max-Q (Turing) hybrid graphics, confirmed via `lspci`.
# No exact "precision-7540" profile in nixos-hardware; closest generation
# match is dell/precision/5530 (same CPU/GPU family) — composed from the
# same generic pieces it uses instead of copying it wholesale.
{ inputs, ... }:

{
  imports = [
    "${inputs.nixos-hardware}/common/cpu/intel/coffee-lake"
    "${inputs.nixos-hardware}/common/gpu/nvidia/turing"
    "${inputs.nixos-hardware}/common/gpu/nvidia/prime.nix"
    "${inputs.nixos-hardware}/common/pc/laptop"
    "${inputs.nixos-hardware}/common/pc/ssd"

    ../../modules/nixos/nix.nix
    ../../modules/nixos/networking.nix
    ../../modules/nixos/locale.nix
    ../../modules/nixos/boot.nix
    ../../modules/nixos/hardware.nix
    ../../modules/nixos/audio.nix
    ../../modules/nixos/printing.nix
    ../../modules/nixos/user.nix
    ../../modules/nixos/ld.nix
    ../../modules/nixos/gnome.nix
    ../../modules/nixos/apps.nix
    ../../modules/nixos/flatpak.nix
    ../../modules/nixos/virtualisation.nix
  ];

  # PCI bus IDs confirmed on this exact machine via `lspci -nn | grep -E "VGA|3D"`:
  #   00:02.0 Intel UHD Graphics 630   -> PCI:0:2:0
  #   01:00.0 NVIDIA Quadro RTX 3000   -> PCI:1:0:0
  hardware.nvidia.prime = {
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };

  hardware.nvidia = {
    nvidiaSettings = true;
    modesetting.enable = true;
  };

  # Same kernel params as nixos-hardware's dell/precision/5530 (closest official
  # profile, same chassis generation) — not vendored via that profile because it
  # pins the Pascal GPU generation instead of Turing (see comment above).
  boot.kernelParams = [
    # fix lspci hanging with nouveau
    # source https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1803179/comments/149
    "acpi_rev_override=1"
    "acpi_osi=Linux"
    "nouveau.modeset=0"
    "pcie_aspm=force"
    "drm.vblankoffdelay=1"
    "nouveau.runpm=0"
    "mem_sleep_default=deep"
    # fix flicker
    # source https://wiki.archlinux.org/index.php/Intel_graphics#Screen_flickering
    "i915.enable_psr=0"
    "nvidia_drm.modeset=1"
  ];

  services.thermald.enable = true;

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  system.stateVersion = "26.05";
}
