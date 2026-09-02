{
  config,
  inputs,
  lib,
  homeManager,
  ...
}:
let
  hostName = baseNameOf ./.;
  username = config.flake.lib.username;
  system = "aarch64-darwin";
in
{
  flake.homeConfigurations."${username}@${hostName}" =
    inputs.home-manager.lib.homeManagerConfiguration
      {
        pkgs = config.flake.legacyPackages.${system};
        modules = [
          homeManager.${hostName}
          homeManager.base
          homeManager.nix
          homeManager.gh
          homeManager.git
          homeManager.direnv
          homeManager.dotnet
          homeManager.nh
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

  flake.modules.homeManager.${hostName} = {
    host.name = hostName;
    home.stateVersion = "26.05";

    programs.claude-code.package = lib.mkForce null;
    programs.kitty.package = lib.mkForce null;
    programs.zed-editor.package = lib.mkForce null;
  };
}
