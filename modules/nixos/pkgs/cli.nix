{
  flake.modules.nixos.cliPkgs =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        wget
        curl
        btop
      ];
    };
}
