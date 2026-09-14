{
  flake.modules.homeManager.dbeaver =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.dbeaver-bin ];
    };
}
