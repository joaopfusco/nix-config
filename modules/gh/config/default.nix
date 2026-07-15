{ pkgs, lib, ... }:
{
  programs.gh = {
    enable = true;
    package = lib.mkDefault pkgs.emptyDirectory;
    settings = {
      git_protocol = "ssh";
      prompt = "enabled";
      aliases = {
        co = "pr checkout";
      };
    };
  };

  # `gh auth login` manages ~/.config/gh/hosts.yml (auth state) at runtime — not declared here.
}
