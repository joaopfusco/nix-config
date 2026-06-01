{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # general
    fastfetch
    gnumake
    terraform
    azure-cli
    claude-code
    devenv
    # python
    python3
    uv
    # node
    nodejs
    pnpm
  ];
}
