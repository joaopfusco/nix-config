{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # Linguagens de Programação
    python312 # v3.12.12
    nodejs_24 # v24
    go_1_25 # v1.25.7

    # Rust - Obs.: Melhor instlar via script do site oficial
    # rustup

    # Ferramentas
    uv
  ];

  # Ou home.sessionPath ou ~/.profile
  # home.sessionPath = [
  #   "$HOME/.cargo/bin"
  # ];
}