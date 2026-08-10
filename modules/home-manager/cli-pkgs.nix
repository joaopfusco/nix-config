{
  flake.modules.homeManager.cliPkgs =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        nixd
        devenv
        fastfetch
        gnumake
        eza
        azure-cli
        codex
      ];
    };
}
