{
  flake.modules.homeManager.dotnet =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (pkgs) dotnetCorePackages;

      mkDotnet =
        name: sdk:
        if pkgs.stdenv.isLinux then
          pkgs.buildFHSEnv {
            inherit name;
            targetPkgs =
              pkgs: with pkgs; [
                sdk
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
          pkgs.writeShellScriptBin name ''
            export DOTNET_ROOT=${sdk}
            exec ${sdk}/bin/dotnet "$@"
          '';
    in
    {
      options.dotnetSdks.installPackages = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Install the dotnet SDK packages (disable to keep only the session config below).";
      };

      config = {
        home.packages =
          lib.optionals config.dotnetSdks.installPackages [
            (mkDotnet "dotnet8" dotnetCorePackages.sdk_8_0)
            (mkDotnet "dotnet9" dotnetCorePackages.sdk_9_0)
            (mkDotnet "dotnet10" dotnetCorePackages.sdk_10_0)
            (pkgs.writeShellScriptBin "dotnet" ''exec dotnet8 "$@"'')
          ]
          ++ [
            pkgs.dotnet-ef # dotnet tool install --global dotnet-ef
          ];

        home.sessionPath = [
          "${config.home.homeDirectory}/.dotnet/tools"
        ];

        home.sessionVariables = {
          DOTNET_CLI_TELEMETRY_OPTOUT = "1";
          DOTNET_NOLOGO = "1";
        };
      };
    };
}
