{
  flake.modules.nixos.networking =
    { config, ... }:
    {
      networking.hostName = config.host.name;
      networking.networkmanager.enable = true;
      networking.firewall.enable = true;
    };
}
