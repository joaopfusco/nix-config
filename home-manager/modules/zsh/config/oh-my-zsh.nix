{ ... }:
{
  programs.zsh.oh-my-zsh = {
    enable = true;
    plugins = [
      "git"
      "docker"
    ];
    # theme = "robbyrussell";
  };
}
