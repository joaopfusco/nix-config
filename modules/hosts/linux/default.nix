{
  config,
  inputs,
  lib,
  ...
}:
let
  hostName = baseNameOf ./.;
  username = config.flake.lib.username;
  system = "x86_64-linux";
in
{
  flake.homeConfigurations."${username}@${hostName}" =
    inputs.home-manager.lib.homeManagerConfiguration
      {
        pkgs = config.flake.legacyPackages.${system};
        modules =
          (with config.flake.modules.homeManager; [
            base
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
            gnome
          ])
          ++ [
            {
              host.name = hostName;
              home.stateVersion = "26.05";
              programs.claude-code.package = lib.mkForce null;
              programs.zed-editor.package = lib.mkForce null;
            }
          ];
      };
}
