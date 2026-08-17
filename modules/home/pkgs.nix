{
  flake.modules.homeManager.pkgs =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        nixd
        devenv
        fastfetch
        gnumake
        bat
        eza
        jq
        azure-cli
        codex
      ];
    };
}
