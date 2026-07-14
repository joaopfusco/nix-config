{ host, ... }:
{
  networking.hostName = host;
  networking.networkmanager.enable = true;
  networking.firewall.enable = true;
}
