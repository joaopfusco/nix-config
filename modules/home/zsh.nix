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
          if [[ -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]]; then
            . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
          fi

          export PATH="$HOME/.local/bin:$PATH"
          export PATH=/Users/joaop/.opencode/bin:$PATH

          if [[ -d /opt/homebrew ]]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
          elif [[ -d /home/linuxbrew/.linuxbrew ]]; then
            eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
          fi

          autoload -U select-word-style
          select-word-style bash
          bindkey '^H' backward-kill-word

          export NIXPKGS_ALLOW_UNFREE=1
          export NIXPKGS_ALLOW_UNSUPPORTED_SYSTEM=1

          flake-lock-age() {
            git -C ${config.host.configDir} log -1 --format='%cd (%cr)' --date=short -- flake.lock
          }

          flake-lock-push() {
            git -C ${config.host.configDir} add flake.lock &&
            git -C ${config.host.configDir} commit -m 'chore: update flake.lock' &&
            git -C ${config.host.configDir} push
          }

          flake-lock-revert() {
            git -C ${config.host.configDir} diff --quiet -- flake.lock \
            && git -C ${config.host.configDir} checkout HEAD~1 -- flake.lock \
            || git -C ${config.host.configDir} checkout -- flake.lock
          }
        '';

        oh-my-zsh = {
          enable = true;
          plugins = [ ];
          theme = "robbyrussell";
        };
      };
    };
}
