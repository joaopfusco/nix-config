{
  flake.modules.homeManager.pkgs =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        nixd
        devenv
        fastfetch
        nano
        bat
        eza
        jq
        gnumake
        azure-cli
        codex
      ];
    };
}
