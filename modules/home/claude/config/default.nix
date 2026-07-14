{ lib, ... }:
{
  programs.claude-code = {
    enable = true;
    # config-only by default: settings.json + agents/commands/hooks/rules/skills
    # are managed here regardless; the `claude` binary itself is a separate call.
    package = lib.mkDefault null;

    settings = {
      env = { };
      theme = "dark";
      autoMemoryEnabled = true;

      hooks = {
        PreToolUse = [
          {
            matcher = "Edit|Write|MultiEdit";
            hooks = [
              {
                type = "command";
                command = "$HOME/.claude/hooks/block-secrets.sh";
              }
            ];
          }
          {
            matcher = "Bash";
            hooks = [
              {
                type = "command";
                command = "$HOME/.claude/hooks/protect-main.sh";
              }
              {
                type = "command";
                command = "$HOME/.claude/hooks/log-commands.sh";
              }
            ];
          }
        ];
      };

      extraKnownMarketplaces = {
        # in case it is not included by default run:
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
        "superpowers@claude-plugins-official" = true;
        ## language servers
        "pyright-lsp@claude-plugins-official" = true;
        "typescript-lsp@claude-plugins-official" = true;
        "csharp-lsp@claude-plugins-official" = true;
        "gopls-lsp@claude-plugins-official" = true;
        "rust-analyzer-lsp@claude-plugins-official" = true;
      };
    };

    context = ./CLAUDE.md;
    agentsDir = ./agents;
    commandsDir = ./commands;
    hooksDir = ./hooks;
    rulesDir = ./rules;
    skills = ./skills;
  };

  # Not a first-class programs.claude-code option — plain directory symlink.
  home.file.".claude/references".source = ./references;
}
