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
      NIXSH_ACTIVE=1 nix shell "''${args[@]}" -c zsh
    }

    nix_shell_prompt_info() {
      if [[ -n "$NIXSH_ACTIVE" ]]; then
        print -n "%F{4}(nix-sh)%f "
      elif [[ -n "$DEVENV_ROOT" ]]; then
        print -n "%F{4}(devenv-shell)%f "
      elif [[ -n "$IN_NIX_SHELL" ]]; then
        print -n "%F{4}(nix-shell)%f "
      fi
    }
    PROMPT+='$(nix_shell_prompt_info)'
  '';
}
