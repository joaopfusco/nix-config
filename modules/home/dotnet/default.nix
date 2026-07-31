{ pkgs, ... }:

let
  inherit (pkgs) dotnetCorePackages;

  mkDotnet =
    name: sdk:
    if pkgs.stdenv.isLinux then
      pkgs.buildFHSEnv {
        inherit name;

        targetPkgs = pkgs: with pkgs; [
          # sdk
          sdk

          # tools
          dotnet-ef

          # deps
          icu
          openssl
          zlib
          curl
          krb5
        ];

        runScript = pkgs.writeShellScript "${name}-entry" ''
          export DOTNET_ROOT=/usr/share/dotnet
          exec /usr/bin/dotnet "$@"
        '';

        extraBuildCommands = ''
          cat > $out/etc/os-release <<'EOF'
          ID=linux
          NAME="Linux"
          PRETTY_NAME="Linux"
          EOF
        '';
      }
    else
      pkgs.runCommand name { } ''
        mkdir -p $out/bin
        ln -s ${sdk}/bin/dotnet $out/bin/${name}
      '';
in
{
  imports = [
    ./config
  ];

  home.packages = [
    # dotnet sdks
    (mkDotnet "dotnet8" dotnetCorePackages.sdk_8_0)
    (mkDotnet "dotnet9" dotnetCorePackages.sdk_9_0)
    (mkDotnet "dotnet10" dotnetCorePackages.sdk_10_0)
    # `dotnet` -> default version.
    (pkgs.writeShellScriptBin "dotnet" ''exec dotnet8 "$@"'')
  ];
}