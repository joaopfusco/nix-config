{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # nix
    home-manager
    nixfmt
    nixd
    devenv
    
    # tools
    fastfetch
    gnumake
    tree
    
    # node
    nodejs_24
    pnpm
    
    # python
    python3
    uv
  ];
}
