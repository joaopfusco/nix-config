{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    dotDir = "${config.xdg.configHome}/zsh";

    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    
    shellAliases = {
      # Common aliases
      ll = "ls -l";
      la = "ls -la";
      cls = "clear";

      # Flake aliases
      flake-update = "nix flake update";

      # Home aliases
      home-switch = "home-manager switch --flake .#joaop";

      # NixOS aliases
      nixos-switch = "sudo nixos-rebuild switch --flake .#$(hostname)";
      nixos-upgrade = "nix flake update && sudo nixos-rebuild switch --flake .#$(hostname)";
      nixos-test = "sudo nixos-rebuild test --flake .#$(hostname)";
      nixos-gens = "sudo nixos-rebuild list-generations";
      nixos-rollback = "sudo nixos-rebuild switch --rollback";
      nixos-fix-boot = "sudo /run/current-system/bin/switch-to-configuration boot";
    };

    initContent = ''
    '';

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "z" ];
      # theme = "robbyrussell";
    };
  };
}
