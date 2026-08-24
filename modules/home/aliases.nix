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
        fetch = "fastfetch --logo nixos";

        # Brew
        brew-upgrade = "brew update && brew upgrade && brew cleanup";

        # Determinate Nix
        dnix-upgrade = "sudo determinate-nixd upgrade";
        dnix-version = "determinate-nixd version";

        # Nix
        nix-upgrade = "sudo -i nix upgrade-nix";

        # Nix Flake
        flake-lock-age = "git -C ${nixConfigDir} log -1 --format='%cd (%cr)' --date=short -- flake.lock";
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

        # Nix Switch
        home-switch = "(cd ${nixConfigDir} && nix fmt) && home-manager switch --flake ${nixConfigDir}#${username}@${hostName}";
        nixos-switch = "(cd ${nixConfigDir} && nix fmt) && sudo nixos-rebuild switch --flake ${nixConfigDir}#${hostName}";
        darwin-switch = "(cd ${nixConfigDir} && nix fmt) && sudo darwin-rebuild switch --flake ${nixConfigDir}#${hostName}";
      };
    };
}
