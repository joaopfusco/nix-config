{
  flake.modules.homeManager.aliases = {
    home.shellAliases = {
      # Common aliases
      l = "eza -l";
      ls = "l";
      la = "eza -la";
      lt = "eza --tree";
      cls = "clear && printf '\\033[3J'";
      ipe = "curl ifconfig.me";
      nfetch = "fastfetch --logo nixos";

      # Brew
      brew-upgrade = "brew update && brew upgrade && brew cleanup";

      # Determinate Nix
      dnix-upgrade = "sudo determinate-nixd upgrade";
      dnix-version = "determinate-nixd version";

      # Nix
      nix-upgrade = "sudo -i nix upgrade-nix";
    };
  };
}
