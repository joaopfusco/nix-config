{
  flake.modules.homeManager.opencode =
    { pkgs, lib, ... }:
    {
      programs.opencode = {
        enable = true;
        package = pkgs.opencode;
        extraPackages =
          with pkgs;
          [
            typescript-language-server
            pyright
            rust-analyzer
            gopls
          ]
          ++ lib.optional (!stdenv.isDarwin) csharp-ls;
        enableMcpIntegration = true;
        settings = builtins.fromJSON (builtins.readFile ./settings.json);
        context = ./context.md;
      };
    };
}
