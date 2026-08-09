{
  flake.modules.homeManager.cliTools =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        home-manager
        nixfmt
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
