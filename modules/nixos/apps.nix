{ pkgs, ... }:
{
  programs.firefox.enable = true;

  environment.systemPackages = with pkgs; [
    # GUI apps
    libreoffice
    vlc
    obs-studio
    google-chrome
    vscode
    dbeaver-bin
    postman

    # CLI tools
    wget
    curl
    btop
    distrobox

    # Multimedia codecs
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-libav
  ];
}
