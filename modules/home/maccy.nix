{
  flake.modules.homeManager.maccy =
    { pkgs, lib, ... }:
    {
      home.packages = [ pkgs.maccy ];

      launchd.agents.maccy = {
        enable = true;
        config = {
          ProgramArguments = [ "${pkgs.maccy}/Applications/Maccy.app/Contents/MacOS/Maccy" ];
          RunAtLoad = true;
          ProcessType = "Interactive";
        };
      };

      home.activation.maccyConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        run /usr/bin/defaults write org.p0deje.Maccy pasteByDefault -bool false
        run /usr/bin/defaults write org.p0deje.Maccy sortBy -string lastCopiedAt
        run /usr/bin/defaults write org.p0deje.Maccy popupPosition -string statusItem
        # Shift+Cmd+V: carbonKeyCode 9 = V, carbonModifiers 768 = cmd|shift
        run /usr/bin/defaults write org.p0deje.Maccy KeyboardShortcuts_popup -string '{"carbonKeyCode":9,"carbonModifiers":768}'
      '';
    };
}
