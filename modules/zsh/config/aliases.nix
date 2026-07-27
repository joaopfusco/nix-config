{
  config,
  username,
  host,
  ...
}:

let
  nixConfigDir = "${config.home.homeDirectory}/nix-config";
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
}
