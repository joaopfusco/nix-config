{ pkgs, ... }:
{
  programs.claude-code = {
    enable = true;
    settings = {
      theme = "dark";
      env.DISABLE_TELEMETRY = "1";
      autoMemoryEnabled = true;

      extraKnownMarketplaces = {
        # claude plugin marketplace add anthropics/claude-plugins-official
        claude-plugins-official = {
          source = {
            source = "github";
            repo = "anthropics/claude-plugins-official";
          };
        };
      };

      enabledPlugins = {
        # claude-plugins-official
        ## workflow
        "frontend-design@claude-plugins-official" = true;
        "feature-dev@claude-plugins-official" = true;
        "pr-review-toolkit@claude-plugins-official" = true;
        "commit-commands@claude-plugins-official" = true;
        "security-guidance@claude-plugins-official" = true;
        "code-review@claude-plugins-official" = true;
        "code-simplifier@claude-plugins-official" = true;
        "claude-md-management@claude-plugins-official" = true;
        ## language servers
        "pyright-lsp@claude-plugins-official" = true;
        "typescript-lsp@claude-plugins-official" = true;
        "csharp-lsp@claude-plugins-official" = true;
        "gopls-lsp@claude-plugins-official" = true;
        "rust-analyzer-lsp@claude-plugins-official" = true;
      };
    };
  };

  home.packages = with pkgs; [
      # python
      pyright
      # node
      typescript-language-server
      # go
      gopls
      # rust
      rust-analyzer
      # dotnet
      csharp-ls
    ];
}
