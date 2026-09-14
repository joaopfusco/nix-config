{
  flake.modules.homeManager.postman = { pkgs, ... }: {
    home.packages = [ pkgs.postman ];
  };
}
