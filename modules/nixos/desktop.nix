{
  flake.modules.nixos.desktop = {
    hardware.graphics.enable = true;

    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    services.xserver.xkb = {
      layout = "us";
      variant = "intl";
    };
  };
}
