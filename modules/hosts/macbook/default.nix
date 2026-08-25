{
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
    modules = [
      darwin.${hostName}
      darwin.base
      darwin.user
      darwin.nix
      darwin.pkgs
      darwin.homebrew
    ];
    specialArgs.homeManagerModules = [
      homeManager.base
      homeManager.nix
      homeManager.gh
      homeManager.git
      homeManager.direnv
      homeManager.dotnet
      homeManager.pkgs
      homeManager.fonts
      homeManager.zsh
      homeManager.aliases
      homeManager.starship
      homeManager.opencode
      homeManager.claudeCode
      homeManager.zedEditor
      homeManager.kitty
    ];
  };

  flake.modules.darwin.${hostName} =
    { config, homeManagerModules, ... }:
    {
      host.name = hostName;
      system.stateVersion = 7;

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
