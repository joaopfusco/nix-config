{ config, inputs, lib, ... }:
{
  flake.homeConfigurations."joaop@notebook" = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = import inputs.nixpkgs {
      system = "x86_64-linux";
      overlays = builtins.attrValues config.flake.overlays;
      config.allowUnfree = true;
    };
    modules = (with config.flake.modules.homeManager; [
      base
      gh
      git
      direnv
      nodejs
      python
      dotnet
      cliTools
      zsh
      starship
      claudeCode
      zedEditor
      kitty
    ]) ++ [
      {
        host.name = "notebook";
        host.stateVersion.home = "26.05";
        dotnetSdks = lib.mkForce [ ];
        programs.claude-code.package = lib.mkForce null;
        programs.zed-editor.package = lib.mkForce null;
        programs.kitty.package = lib.mkForce null;
      }
    ];
  };
}
