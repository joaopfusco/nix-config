{ config, ... }:
let
  homeManager = config.flake.modules.homeManager;
in
{
  flake.modules.homeManager.nixosAliases =
    { config, ... }:
    let
      nixConfigDir = "${config.home.homeDirectory}/nix-config";
      hostName = config.host.name;
    in
    {
      imports = [ homeManager.aliases ];
      home.shellAliases = {
        nixos-switch = ''
          (cd ${nixConfigDir} && nix fmt) &&
          sudo nixos-rebuild switch --flake ${nixConfigDir}#${hostName}
        '';
        nixos-upgrade = ''
          git -C ${nixConfigDir} pull --rebase &&
          nix flake update --flake ${nixConfigDir} &&
          nixos-switch
        '';
        nixos-test = "sudo nixos-rebuild test --flake ${nixConfigDir}#${hostName}";
        nixos-gens = "sudo nixos-rebuild list-generations";
        nixos-rollback = "sudo nixos-rebuild switch --rollback";
        nixos-fix-boot = "sudo /run/current-system/bin/switch-to-configuration boot";
      };
    };
}
