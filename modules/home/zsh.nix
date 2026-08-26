{
  flake.modules.homeManager.zsh =
    { config, ... }:
    let
      nixConfigDir = "${config.home.homeDirectory}/nix-config";
      hostName = config.host.name;
      username = config.host.user.name;
    in
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

          flake-lock-age() {
            git -C ${nixConfigDir} log -1 --format='%cd (%cr)' --date=short -- flake.lock
          }

          flake-lock-push() {
            git -C ${nixConfigDir} add flake.lock &&
            git -C ${nixConfigDir} commit -m 'chore: update flake.lock' &&
            git -C ${nixConfigDir} push
          }

          flake-lock-revert() {
            git -C ${nixConfigDir} diff --quiet -- flake.lock \
              && git -C ${nixConfigDir} checkout HEAD~1 -- flake.lock \
              || git -C ${nixConfigDir} checkout -- flake.lock
          }

          home-switch() {
            (cd ${nixConfigDir} && nix fmt) && home-manager switch --flake ${nixConfigDir}#${username}@${hostName} "$@"
          }

          nixos-switch() {
            (cd ${nixConfigDir} && nix fmt) && sudo nixos-rebuild switch --flake ${nixConfigDir}#${hostName} "$@"
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
