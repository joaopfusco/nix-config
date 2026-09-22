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
  system = "x86_64-linux";
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
          homeManager.opencode
          homeManager.claudeCode
          homeManager.zedEditor
          homeManager.kitty
          homeManager.copyq
        ];
      };

  flake.modules.homeManager.${hostName} = { pkgs, ... }: {
    host.name = hostName;
    home.stateVersion = "26.05";

    targets.genericLinux = {
      enable = true;
      gpu.enable = true;
    };

    programs.claude-code.package = lib.mkForce null;
    programs.opencode = {
      package = lib.mkForce pkgs.emptyDirectory;
      extraPackages = lib.mkForce [ ];
    };
    programs.zed-editor.package = lib.mkForce null;
  };
}
