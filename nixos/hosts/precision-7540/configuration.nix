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

    ../../modules/nix/config.nix
    ../../modules/nix/ld.nix
    ../../modules/networking.nix
    ../../modules/locale.nix
    ../../modules/user.nix

    ../../modules/boot/inotify.nix
    ../../modules/boot/systemd-boot.nix

    ../../modules/hardware/common.nix
    ../../modules/hardware/intel.nix
    ../../modules/hardware/nvidia.nix
    ../../modules/hardware/audio.nix

    ../../modules/desktop/gnome.nix
    ../../modules/pkgs/deps.nix
    ../../modules/pkgs/cli.nix
    ../../modules/pkgs/gui.nix
    ../../modules/pkgs/flatpak.nix

    ../../modules/virtualisation/docker.nix
    ../../modules/virtualisation/vm.nix
  ];

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

  system.stateVersion = "26.05";
}
