{
  flake.modules.homeManager.cliTools =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
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
