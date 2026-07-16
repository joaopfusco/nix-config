{ pkgs, ... }:

let
  dotnet-stack = (
    with pkgs.dotnetCorePackages;
    combinePackages [
      sdk_8_0
      sdk_9_0
      sdk_10_0
    ]
  );

  dotnet-wrapped = pkgs.symlinkJoin {
    name = "dotnet-wrapped";
    paths = [ dotnet-stack ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/dotnet \
        --prefix LD_LIBRARY_PATH : "${pkgs.glibc}/lib"
    '';
  };
in
{
  imports = [
    ./config
  ];

  home.packages = [
    dotnet-wrapped
    pkgs.dotnet-ef # dotnet tool install --global dotnet-ef
    pkgs.csharp-ls # dotnet tool install --global csharp-ls
  ];

  home.sessionVariables = {
    DOTNET_ROOT = "${dotnet-wrapped}";
  };
}
