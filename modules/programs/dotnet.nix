{
  flake.modules.homeManager.dotnet =
    { config, lib, pkgs, ... }:
    let
      inherit (pkgs) dotnetCorePackages;

      mkDotnet =
        name: sdk:
        if pkgs.stdenv.isLinux then
          pkgs.buildFHSEnv {
            inherit name;

            targetPkgs = pkgs: with pkgs; [
              sdk
              dotnet-ef
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
      options.dotnetSdks = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        default = [
          (mkDotnet "dotnet8" dotnetCorePackages.sdk_8_0)
          (mkDotnet "dotnet9" dotnetCorePackages.sdk_9_0)
          (mkDotnet "dotnet10" dotnetCorePackages.sdk_10_0)
          (pkgs.writeShellScriptBin "dotnet" ''exec dotnet8 "$@"'')
        ];
        description = ''
          SDKs do .NET instalados via Nix (FHS envs pesados). Hosts que não
          querem o Nix dono desses binários sobrescrevem com `lib.mkForce [ ]`
          — o `dotnet-ef` continua instalado de qualquer forma.
        '';
      };

      config = {
        home.packages = config.dotnetSdks ++ [ pkgs.dotnet-ef ];

        home.sessionPath = [ "${config.home.homeDirectory}/.dotnet/tools" ];

        home.sessionVariables = {
          DOTNET_CLI_TELEMETRY_OPTOUT = "1";
          DOTNET_NOLOGO = "1";
        };
      };
    };
}
