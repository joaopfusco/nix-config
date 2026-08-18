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
          discard = "!f() { d=\"\${1:-.}\"; git restore --staged \"$d\" && git restore \"$d\" && git clean -fd \"$d\"; }; f";
        };
        credential = {
          helper = "store";
        };
      };
    };
  };
}
