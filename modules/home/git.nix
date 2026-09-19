{
  flake.modules.homeManager.git = {
    programs.git = {
      enable = true;
      settings = {
        user = {
          name = "joaopfusco";
          email = "joaopedrofusco@gmail.com";
        };
        alias = {
          graph = "!git log --graph --oneline --decorate";
          discard = "!f() { d=\"\${1:-.}\"; git restore --staged \"$d\" && git restore \"$d\" && git clean -fd \"$d\"; }; f";
        };
        credential = {
          helper = "store";
        };
      };
      ignores = [
        ".DS_Store"
        "**/.claude/settings.local.json"
      ];
    };
  };
}
