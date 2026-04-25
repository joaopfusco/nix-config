{ config, pkgs, ... }:

{
  # Enable thermald (Intel CPUs)
  services.thermald.enable = true;

  # Intel GPU drivers
  services.xserver.videoDrivers = [ "modesetting" ];
}
