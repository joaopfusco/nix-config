{ ... }:
{
  programs.zsh = {
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "docker"
      ];
      theme = "robbyrussell";
    };
  };
}
