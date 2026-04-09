{ config, pkgs, ... }:

{
  # Install Firefox
  programs.firefox.enable = true;

  # Install Zsh
  programs.zsh.enable = true;

  # Docker
  virtualisation.docker.enable = true;

  # VM management
  programs.virt-manager.enable = true;
  virtualisation.libvirtd = {
    enable = true; 
    qemu.swtpm.enable = true;
  };
  virtualisation.spiceUSBRedirection.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # Basic utilities
    wget
    curl
    
    # Media codecs (GStreamer)
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-libav

    # GUI applications
    vlc
    libreoffice
    google-chrome
  ];

  # Enable Flatpak support
  services.flatpak.enable = true;
  # Run flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
}
