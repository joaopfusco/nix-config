{
  flake.modules.homeManager.cliPkgs =
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
