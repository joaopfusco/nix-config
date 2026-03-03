# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, host, username, ... }:

{
  # Bootloader
  # boot.loader.systemd-boot.enable = true;
  # boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.enable = true;
  boot.loader.grub.devices = [ "/dev/vda" ];
  boot.loader.grub.useOSProber = true;

  # Set your hostname
  networking.hostName = host;

  # Enable networking
  networking.networkmanager.enable = true;
  networking.firewall.enable = true;

  # Enable all firmware to support a wide range of hardware.
  hardware.enableAllFirmware = true;
  hardware.enableRedistributableFirmware = true;
  services.power-profiles-daemon.enable = true;

  # Enable Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # Enable graphics and hardware acceleration
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # AMD GPU drivers
  # services.xserver.videoDrivers = [ "amdgpu" ];

  # Intel GPU drivers
  # services.xserver.videoDrivers = [ "modesetting" ];

  # NVIDIA GPU drivers
  # services.switcherooControl.enable = true;
  # services.xserver.videoDrivers = [ "nvidia" ];
  # hardware.nvidia = {
  #   # Modesetting is critical for Wayland support
  #   modesetting.enable = true;

  #   # Enable power management features for NVIDIA GPUs, including fine-grained power management.
  #   powerManagement.enable = true;
  #   powerManagement.finegrained = true;

  #   # Enable the NVIDIA settings menu (nvidia-settings)
  #   nvidiaSettings = true;

  #   # Using the proprietary NVIDIA driver
  #   open = false;

  #   # Select the driver package version
  #   package = config.boot.kernelPackages.nvidiaPackages.stable;

  #   # Enable NVIDIA Prime for hybrid graphics setups (e.g., laptops with both integrated and discrete GPUs)
  #   prime = {
  #     offload = {
  #       enable = true;
  #       enableOffloadCmd = true;
  #     };

  #     # Run 'nix-shell -p lshw --run "sudo lshw -c display"'.
  #     intelBusId = "PCI:0:2:0";
  #     nvidiaBusId = "PCI:1:0:0";
  #   };
  # };

  # Set your time zone.
  time.timeZone = "America/Sao_Paulo";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_BR.UTF-8";
    LC_IDENTIFICATION = "pt_BR.UTF-8";
    LC_MEASUREMENT = "pt_BR.UTF-8";
    LC_MONETARY = "pt_BR.UTF-8";
    LC_NAME = "pt_BR.UTF-8";
    LC_NUMERIC = "pt_BR.UTF-8";
    LC_PAPER = "pt_BR.UTF-8";
    LC_TELEPHONE = "pt_BR.UTF-8";
    LC_TIME = "pt_BR.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.displayManager.gdm.enable = true;
  services.displayManager.gdm.wayland = true;
  services.desktopManager.gnome.enable = true;

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  
  # Enable Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "alt-intl";
    options  = "grp:win_space_toggle";
  };

  # Configure console keymap
  console.keyMap = "us";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Enable Flatpak support
  services.flatpak.enable = true;
  # Run flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

  # Docker
  virtualisation.docker.enable = true;

  # VMs
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${username} = {
    shell = pkgs.zsh;
    isNormalUser = true;
    description = "Joao Pedro Fusco";
    extraGroups = [ "networkmanager" "wheel" "docker" "libvirtd" "dialout" ];
  };
  
  # Install Firefox
  programs.firefox.enable = true;

  # Install Zsh
  programs.zsh.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # Basic utilities
    home-manager
    wget
    curl
    git
    distrobox
    distroshelf

    # Media codecs (GStreamer)
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-libav
  ];

  # Enable nix-ld to allow running dynamically linked binaries from the Nix store
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # Basic libraries and dependencies
    stdenv.cc.cc
    zlib
    fuse3
    icu
    nss
    openssl
    curl
    expat
  ];

  # Automatically optimize the Nix store to save disk space
  nix.optimise.automatic = true;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  system.stateVersion = "25.11";
}