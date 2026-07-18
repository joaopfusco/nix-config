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

  dotnetTargetPkgs =
    pkgs:
    with pkgs;
    [
      # Dotnet SDKs
      dotnet-stack

      # Dotnet tools
      dotnet-ef # dotnet tool install --global dotnet-ef
      csharp-ls # dotnet tool install --global csharp-ls

      # Dotnet deps
      icu
      openssl
      zlib
      curl
      krb5
    ];

  mkDotnetFHS = name: pkgs.buildFHSEnv {
    inherit name;
    targetPkgs = dotnetTargetPkgs;
    runScript = pkgs.writeShellScript "${name}-entry" ''
      export DOTNET_ROOT=/usr/share/dotnet
      exec /usr/bin/${name} "$@"
    '';
  };
in
{
  imports = [
    ./config
  ];

  home.packages = [
    (mkDotnetFHS "dotnet")
    (mkDotnetFHS "dotnet-ef")
    (mkDotnetFHS "csharp-ls")
  ];
}
