{ pkgs, ... }:
{
  imports = [ ./config ];
  home.packages = with pkgs; [ copyq ];
}
