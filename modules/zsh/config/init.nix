{ ... }:

{
  programs.zsh.initContent = ''
    if [[ -d /opt/homebrew ]]; then
      eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -d /home/linuxbrew/.linuxbrew ]]; then
      eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    fi

    autoload -U select-word-style
    select-word-style bash

    bindkey '^H' backward-kill-word
    bindkey '^[[3;5~' kill-word

    bindkey "^[[1;5C" forward-word
    bindkey "^[[1;5D" backward-word

    export NIXPKGS_ALLOW_UNFREE=1

    nix-sh() {
      local args=()
      for arg in "$@"; do
        case $arg in
          -*|*#*|*:*|.*|/*) args+=("$arg") ;;
          *) args+=("pkgs#$arg") ;;
        esac
      done
      NIXSH_ACTIVE="$*" nix shell "''${args[@]}" -c zsh
    }
  '';
}
