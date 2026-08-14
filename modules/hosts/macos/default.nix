{
  config,
  inputs,
  lib,
  ...
}:
let
  hostName = baseNameOf ./.;
in
{
  flake.darwinConfigurations.${hostName} = inputs.nix-darwin.lib.darwinSystem {
    system = "aarch64-darwin";
    specialArgs.homeManagerModules = with config.flake.modules.homeManager; [
      base
      nixGc
      gh
      git
      direnv
      nodejs
      python
      dotnet
      pkgs
      zsh
      aliases
      starship
      claudeCode
      zedEditor
      kitty
    ];
    modules =
      (with config.flake.modules.darwin; [
        base
        user
        common
        pkgs
        homebrew
      ])
      ++ [
        (
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
                programs.zed-editor.package = lib.mkForce null;
                programs.kitty.package = lib.mkForce null;
              };
            };
          }
        )
      ];
  };
}
