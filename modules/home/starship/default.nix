{ ... }:
{
  imports = [ ./config ];
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };
}
