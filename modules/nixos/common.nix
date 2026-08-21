{
  flake.modules.nixos.common =
    { config, ... }:
    {
      # inotify
      boot.kernel.sysctl = {
        "fs.inotify.max_user_watches" = 524288;
        "fs.inotify.max_user_instances" = 512;
      };

      # networking
      networking.hostName = config.host.name;
      networking.networkmanager.enable = true;
      networking.firewall.enable = true;

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

      console.keyMap = "us-acentos";
    };
}
