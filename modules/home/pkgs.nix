{
  flake.modules.homeManager.pkgs =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        nixd
        devenv
        fastfetch
        gnumake
        eza
        jq
        azure-cli
        codex
        python3
        uv
        nodejs_24
        pnpm
      ];
    };
}
