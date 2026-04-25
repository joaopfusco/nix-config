{ config, ... }:

{
  # AMD GPU drivers
  services.xserver.videoDrivers = [ "amdgpu" ];
}
