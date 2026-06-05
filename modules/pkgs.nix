{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # general
    fastfetch
    gnumake
    terraform
    azure-cli
    devenv
    # python
    python3
    uv
    # node
    nodejs
    pnpm
  ];
}
