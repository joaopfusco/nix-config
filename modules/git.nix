{ ... }:

{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "joaopfusco";
        email = "joaopedrofusco@gmail.com";
      };
      alias = {
        lg = "log --oneline --graph --all";
      };
      credential = {
        helper = "store";
      };
    };
  };
}
