{
  flake.modules.homeManager.gh = {
    # `gh auth login` gerencia ~/.config/gh/hosts.yml (auth state) em runtime.
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
  };
}
