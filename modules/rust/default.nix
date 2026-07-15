{ pkgs, ... }:
{
  imports = [ ./config ];
  home.packages = [
    pkgs.cargo
    pkgs.rustc
  ];
}
