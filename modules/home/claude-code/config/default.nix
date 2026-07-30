{ pkgs, config, ... }:
let
  linkConfig =
    name:
    config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/nix-config/modules/home/claude-code/config/${name}";
in
{
  programs.claude-code = {
    enable = true;
    package = config.lib.own.mkConfigOnly "claude-code";
  };

  home.file = {
    ".claude/CLAUDE.md".source = linkConfig "CLAUDE.md";
    ".claude/settings.json".source = linkConfig "settings.json";
    ".claude/hooks".source = linkConfig "hooks";
    ".claude/rules".source = linkConfig "rules";
    ".claude/skills".source = linkConfig "skills";
    ".claude/references".source = linkConfig "references";
  };

  home.packages = with pkgs; [
    # language servers
    typescript-language-server
    pyright
    rust-analyzer
    gopls
    csharp-ls # dotnet tool install --global csharp-ls
  ];
}
