{ pkgs, lib, ... }:

{
  programs.git = {
    enable = true;
    package = lib.mkDefault null;
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
