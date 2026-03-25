{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # Linguagens de Programação
    python312 # v3.12.12
    nodejs_24 # v24
    go_1_25 # v1.25.7

    # Rust
    cargo
    rustc
    rustfmt
    clippy

    # Ferramentas
    nixfmt
    uv
    terraform
  ];
}