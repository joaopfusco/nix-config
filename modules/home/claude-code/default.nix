{
  flake.modules.homeManager.claudeCode =
    { pkgs, ... }:
    {
      programs.claude-code = {
        enable = true;
        package = pkgs.unstable.claude-code;
        context = ./CLAUDE.md;
        settings = builtins.fromJSON (builtins.readFile ./settings.json);
      };

      home.file = {
        ".claude/hooks".source = ./hooks;
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
