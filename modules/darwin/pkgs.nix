{
  flake.modules.darwin.pkgs =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        wget
        curl
        btop
      ];
    };
}
