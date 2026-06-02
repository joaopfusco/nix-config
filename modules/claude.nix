{ inputs, ... }:
{
  programs.claude-code = {
    enable = true;

    # marketplaces
    marketplaces.anthropic = inputs.claude-plugins;

    # settings
    settings = {
      theme = "dark";
      env.DISABLE_TELEMETRY = "1";
      enabledPlugins = {
        "frontend-design@anthropic" = true;
        "feature-dev@anthropic" = true;
        "pr-review-toolkit@anthropic" = true;
        "commit-commands@anthropic" = true;
        "security-guidance@anthropic" = true;
      };
    };
  };
}
