{
  flake.modules.homeManager.zsh =
    { config, ... }:
    {
      programs.zsh = {
        enable = true;
        dotDir = "${config.xdg.configHome}/zsh";

        enableCompletion = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;

        initContent = ''
          if [[ -d /opt/homebrew ]]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
          elif [[ -d /home/linuxbrew/.linuxbrew ]]; then
            eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
          fi

          autoload -U select-word-style
          select-word-style bash
          bindkey '^H' backward-kill-word

          export NIXPKGS_ALLOW_UNFREE=1

          nixsh() {
            IN_NIX_SHELL=impure nix shell "$@" --command zsh
          }

          flake-init() {
            nix flake init --template "github:DeterminateSystems/flake-templates#minimal"
          }

          devenv-init() {
            devenv init "$@" || return 1
            local dir=''${1:-.}
            if [[ ! -f "$dir/.envrc" ]]; then
              printf 'eval "$(devenv direnvrc)"\nuse devenv\n' > "$dir/.envrc"
            fi
          }
        '';

        oh-my-zsh = {
          enable = true;
          plugins = [
            "git"
            "docker"
          ];
          # theme = "robbyrussell";
        };
      };
    };
}
