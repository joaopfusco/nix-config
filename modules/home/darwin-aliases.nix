{ config, ... }:
let
  homeManager = config.flake.modules.homeManager;
in
{
  flake.modules.homeManager.darwinAliases =
    { config, ... }:
    let
      nixConfigDir = "${config.home.homeDirectory}/nix-config";
      hostName = config.host.name;
    in
    {
      imports = [ homeManager.aliases ];
      home.shellAliases = {
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
    };
}
