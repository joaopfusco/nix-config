{
  config,
  inputs,
  lib,
  darwin,
  homeManager,
  ...
}:
let
  hostName = baseNameOf ./.;
in
{
  flake.darwinConfigurations.${hostName} = inputs.nix-darwin.lib.darwinSystem {
    system = "aarch64-darwin";
    specialArgs.homeManagerModules = [
      homeManager.base
      homeManager.nix
      homeManager.gh
      homeManager.git
      homeManager.direnv
      homeManager.dotnet
      homeManager.pkgs
      homeManager.zsh
      homeManager.aliases
      homeManager.starship
      homeManager.claudeCode
      homeManager.zedEditor
      homeManager.kitty
    ];
    modules = [
      darwin.${hostName}
      darwin.base
      darwin.user
      darwin.common
      darwin.pkgs
      darwin.homebrew
    ];
  };

  flake.modules.darwin.${hostName} =
    { config, homeManagerModules, ... }:
    {
      host.name = hostName;
      system.stateVersion = 6;

      home-manager = {
        sharedModules = homeManagerModules;
        users.${config.host.user.name} = {
          host.name = hostName;
          home.stateVersion = "26.05";

          programs.claude-code.package = lib.mkForce null;
          programs.kitty.package = lib.mkForce null;
          programs.zed-editor.package = lib.mkForce null;
        };
      };
    };
}
