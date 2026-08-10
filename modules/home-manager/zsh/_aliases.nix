{ config, ... }:
let
  nixConfigDir = "${config.home.homeDirectory}/nix-config";
  username = config.host.user.name;
  host = config.host.name;
in
{
  programs.zsh.shellAliases = {
    # Common aliases
    ll = "eza -l";
    la = "eza -la";
    lt = "eza --tree";
    cls = "clear && printf '\\033[3J'";
    py = "python3";
    ipe = "curl ifconfig.me";

    # Apt/Brew upgrades
    apt-upgrade = "sudo apt update && sudo apt upgrade -y";
    brew-upgrade = "brew update && brew upgrade && brew cleanup";

    # Determinate Nix
    nixd-upgrade = "sudo determinate-nixd upgrade";
    nixd-version = "determinate-nixd version";

    # Nix Flake
    flake-lock-push = ''
      git -C ${nixConfigDir} add flake.lock &&
      git -C ${nixConfigDir} commit -m 'chore: update flake.lock' &&
      git -C ${nixConfigDir} push
    '';

    # Home Manager
    home-switch = "home-manager switch --flake ${nixConfigDir}#${username}@${host}";
    home-sync = ''
      git -C ${nixConfigDir} pull --rebase &&
      home-manager switch --flake ${nixConfigDir}#${username}@${host}
    '';
    home-upgrade = ''
      git -C ${nixConfigDir} pull --rebase &&
      nix flake update --flake ${nixConfigDir} &&
      home-manager switch --flake ${nixConfigDir}#${username}@${host}
    '';
    home-test = "home-manager switch --flake ${nixConfigDir}#${username}@${host} -n";
    home-gens = "home-manager generations";
    home-rollback = "home-manager switch --flake ${nixConfigDir}#${username}@${host} --rollback";

    # NixOS
    nixos-switch = "sudo nixos-rebuild switch --flake ${nixConfigDir}#${host}";
    nixos-sync = ''
      git -C ${nixConfigDir} pull --rebase &&
      sudo nixos-rebuild switch --flake ${nixConfigDir}#${host}
    '';
    nixos-upgrade = ''
      git -C ${nixConfigDir} pull --rebase &&
      nix flake update --flake ${nixConfigDir} &&
      sudo nixos-rebuild switch --flake ${nixConfigDir}#${host}
    '';
    nixos-test = "sudo nixos-rebuild test --flake ${nixConfigDir}#${host}";
    nixos-gens = "sudo nixos-rebuild list-generations";
    nixos-rollback = "sudo nixos-rebuild switch --rollback";
    nixos-fix-boot = "sudo /run/current-system/bin/switch-to-configuration boot";
  };
}
