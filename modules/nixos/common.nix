{
  flake.modules.nixos.common =
    { config, ... }:
    {
      # nix
      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
      ];
      nix.optimise.automatic = true;
      nix.gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 7d";
      };

      # networking
      networking.hostName = config.host.name;
      networking.networkmanager.enable = true;
      networking.firewall.enable = true;

      # hardware
      hardware.enableAllFirmware = true;
      hardware.enableRedistributableFirmware = true;
      hardware.bluetooth.enable = true;
      hardware.bluetooth.powerOnBoot = true;
      hardware.graphics = {
        enable = true;
        enable32Bit = true;
      };

      # services
      services.fwupd.enable = true;
      services.libinput.enable = true;
      services.libinput.touchpad.tapping = true;
      services.libinput.touchpad.naturalScrolling = true;
      services.printing.enable = true;

      # locale
      time.timeZone = "America/Sao_Paulo";

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
        LC_TIME = "en_US.UTF-8";
      };

      services.xserver.xkb = {
        layout = "us";
        variant = "intl";
      };

      console.keyMap = "us-acentos";

      # audio
      services.pulseaudio.enable = false;
      security.rtkit.enable = true;
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
      };
    };
}
