{
  flake.modules.darwin.aliases =
    { config, lib, ... }:
    let
      nixConfigDir = "/Users/${config.host.user.name}/nix-config";
      hostName = config.host.name;
      aliases = {
        darwin-switch = ''
          (cd ${nixConfigDir} && nix fmt) &&
          sudo darwin-rebuild switch --flake ${nixConfigDir}#${hostName}
        '';
        darwin-upgrade = ''
          git -C ${nixConfigDir} pull --rebase &&
          nix flake update --flake ${nixConfigDir} &&
          darwin-switch
        '';
        darwin-test = "darwin-rebuild check --flake ${nixConfigDir}#${hostName}";
        darwin-gens = "darwin-rebuild --list-generations";
        darwin-rollback = "sudo darwin-rebuild --rollback";
      };
    in
    {
      # nix-darwin's environment.shellAliases only lands in /etc/zprofile
      # (login shells) — not /etc/zshrc, which non-login interactive shells
      # (tmux, VSCode terminal, etc.) actually read. interactiveShellInit
      # is the option nix-darwin's zsh module injects into /etc/zshrc.
      environment.interactiveShellInit = lib.concatStringsSep "\n" (
        lib.mapAttrsToList (name: value: "alias ${name}=${lib.escapeShellArg value}") aliases
      );
    };
}
