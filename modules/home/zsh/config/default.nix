{
  pkgs,
  lib,
  config,
  username,
  host,
  ...
}:

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
      cls = "clear";
      py = "python3";
      ipe = "curl ifconfig.me";
      ins = "echo $IN_NIX_SHELL";
      apt-up = "sudo apt update && sudo apt upgrade -y";
      brew-up = "brew update && brew upgrade && brew cleanup";

      # Home Manager
      home-switch = "home-manager switch --flake .#${username}@${host}";
      home-upgrade = "nix flake update && home-manager switch --flake .#${username}@${host}";

      # NixOS
      nixos-switch = "sudo nixos-rebuild switch --flake .#${host}";
      nixos-upgrade = "nix flake update && sudo nixos-rebuild switch --flake .#${host}";
      nixos-test = "sudo nixos-rebuild test --flake .#${host}";
      nixos-gens = "sudo nixos-rebuild list-generations";
      nixos-rollback = "sudo nixos-rebuild switch --rollback";
      nixos-fix-boot = "sudo /run/current-system/bin/switch-to-configuration boot";

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
