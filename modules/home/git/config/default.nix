{ pkgs, lib, ... }:

{
  programs.git = {
    enable = true;
    package = lib.mkDefault pkgs.emptyDirectory;
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
