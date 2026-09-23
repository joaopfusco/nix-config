{
  flake.modules.homeManager.fish =
    { config, pkgs, ... }:
    {
      programs.fish = {
        enable = true;
        shellAliases = config.home.shellAliases;

        plugins = [
          {
            name = "bass";
            src = pkgs.fishPlugins.bass.src;
          }
        ];

        shellInit = ''
          if test -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
            source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
          end
        '';

        interactiveShellInit = ''
          set -g fish_greeting

          set -gx PATH "$HOME/.local/bin" $PATH
          set -gx PATH "$HOME/.opencode/bin" $PATH

          if test -d /opt/homebrew
            eval (/opt/homebrew/bin/brew shellenv)
          else if test -d /home/linuxbrew/.linuxbrew
            eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv)
          end

          set -gx NIXPKGS_ALLOW_UNFREE 1
        '';

        binds = {
          "\\ch".command = "backward-kill-word";
        };

        functions = {
          flake-init = ''
            nix flake init --template "github:DeterminateSystems/flake-templates#minimal"
          '';

          devenv-init = ''
            devenv init $argv
            or return 1
            set -l dir .
            if test (count $argv) -gt 0
              set dir $argv[1]
            end
            if not test -f "$dir/.envrc"
              printf 'eval "$(devenv direnvrc)"\nuse devenv\n' > "$dir/.envrc"
            end
          '';

          flake-lock-age = ''
            git -C ${config.host.configDir} log -1 --format='%cd (%cr)' --date=short -- flake.lock
          '';

          flake-lock-push = ''
            git -C ${config.host.configDir} add flake.lock
            and git -C ${config.host.configDir} commit -m 'chore: update flake.lock'
            and git -C ${config.host.configDir} push
          '';

          flake-lock-revert = ''
            git -C ${config.host.configDir} diff --quiet -- flake.lock
            and git -C ${config.host.configDir} checkout HEAD~1 -- flake.lock
            or git -C ${config.host.configDir} checkout -- flake.lock
          '';
        };
      };
    };
}
