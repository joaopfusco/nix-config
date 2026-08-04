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
        discard = "!git restore --staged . && git restore . && git clean -fd";
      };
      credential = {
        helper = "store";
      };
    };
  };
}
