{ ... }:
{
  # `gh auth login` manages ~/.config/gh/hosts.yml (auth state) at runtime.
  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
      prompt = "enabled";
      aliases = {
        co = "pr checkout";
      };
    };
  };
}
