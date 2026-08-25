{
  flake.modules.darwin.pkgs =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        btop
      ];
    };
}
