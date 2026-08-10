{
  flake.modules.homeManager.claudeCode =
    { config, pkgs, ... }:
    let
      linkConfig =
        name:
        config.lib.file.mkOutOfStoreSymlink
          "${config.home.homeDirectory}/nix-config/modules/home-manager/claude-code/${name}";
    in
    {
      programs.claude-code.enable = true;

      home.file = {
        ".claude/CLAUDE.md".source = linkConfig "CLAUDE.md";
        ".claude/settings.json".source = linkConfig "settings.json";
        ".claude/hooks".source = linkConfig "hooks";
        ".claude/rules".source = linkConfig "rules";
      };

      home.packages = with pkgs; [
        typescript-language-server
        pyright
        rust-analyzer
        gopls
        csharp-ls
      ];
    };
}
