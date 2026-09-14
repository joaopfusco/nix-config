{
  flake.modules.homeManager.raycast =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.raycast ];

      launchd.agents.raycast = {
        enable = true;
        config = {
          ProgramArguments = [ "${pkgs.raycast}/Applications/Raycast.app/Contents/MacOS/Raycast" ];
          RunAtLoad = true;
          ProcessType = "Interactive";
        };
      };
    };
}
