{
  pkgs,
  lib,
  config,
  username,
  host,
  ...
}:

let
  nixConfigDir = "${config.home.homeDirectory}/nix-config";
in
{
  programs.zsh = {
    enable = true;
    package = lib.mkDefault pkgs.emptyDirectory;
    dotDir = "${config.xdg.configHome}/zsh";

    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      # Common aliases
      ll = "ls -l";
      la = "ls -la";
      cls = "clear && printf '\\033[3J'";
      py = "python3";
      ipe = "curl ifconfig.me";
      ins = "echo $IN_NIX_SHELL";

      # Apt/Brew upgrades
      apt-upgrade = "sudo apt update && sudo apt upgrade -y";
      brew-upgrade = "brew update && brew upgrade && brew cleanup";

      # Home Manager
      home-switch = "home-manager switch --flake ${nixConfigDir}#${username}@${host}";
      home-upgrade = ''
        git -C ${nixConfigDir} pull --rebase &&
        nix flake update --flake ${nixConfigDir} &&
        home-manager switch --flake ${nixConfigDir}#${username}@${host} &&
        git -C ${nixConfigDir} add flake.lock &&
        git -C ${nixConfigDir} commit -m 'chore: update flake.lock' &&
        git -C ${nixConfigDir} push
      '';
      home-test = "home-manager switch --flake ${nixConfigDir}#${username}@${host} -n";
      home-gens = "home-manager generations";
      home-rollback = "home-manager switch --flake ${nixConfigDir}#${username}@${host} --rollback";

      # Determinate Nix
      nixd-upgrade = "sudo determinate-nixd upgrade";
      nixd-version = "determinate-nixd version";
    };

    initContent = ''
      # homebrew
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
        nix shell "''${args[@]}" -c zsh
      }
    '';

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
      ];
      theme = "robbyrussell";
    };
  };
}
