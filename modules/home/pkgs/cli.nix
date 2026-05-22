{ pkgs, ... }:

{
  home.packages = with pkgs; [
    fastfetch
    gnumake
    terraform
    azure-cli
    claude-code
    devenv
    uv
    python3
    nodejs
  ];
}
