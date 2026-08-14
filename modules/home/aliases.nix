{
  flake.modules.homeManager.aliases =
    { config, ... }:
    let
      nixConfigDir = "${config.home.homeDirectory}/nix-config";
      hostName = config.host.name;
      username = config.host.user.name;
    in
    {
      home.shellAliases = {
        # Common aliases
        l = "eza -l";
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

        # Nix
        nix-upgrade = "sudo -i nix upgrade-nix";

        # Nix Flake
        flake-sync = ''
          git -C ${nixConfigDir} pull --rebase
        '';
        flake-lock-push = ''
          git -C ${nixConfigDir} add flake.lock &&
          git -C ${nixConfigDir} commit -m 'chore: update flake.lock' &&
          git -C ${nixConfigDir} push
        '';
        flake-lock-revert = ''
          git -C ${nixConfigDir} diff --quiet -- flake.lock \
            && git -C ${nixConfigDir} checkout HEAD~1 -- flake.lock \
            || git -C ${nixConfigDir} checkout -- flake.lock
          flake-sync
        '';

        # Home Manager
        home-switch = ''
          (cd ${nixConfigDir} && nix fmt) &&
          home-manager switch --flake ${nixConfigDir}#${username}@${hostName}
        '';
        home-upgrade = ''
          git -C ${nixConfigDir} pull --rebase &&
          nix flake update --flake ${nixConfigDir} &&
          home-switch
        '';
        home-test = "home-switch -n";
        home-gens = "home-manager generations";
        home-rollback = "home-switch --rollback";
      };
    };
}
