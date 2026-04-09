{ config, pkgs, ... }:

let
  dotnet-stack = (with pkgs.dotnetCorePackages; combinePackages [
    sdk_8_0
    sdk_9_0
  ]);
  deps = (
    ps:
    with ps;
    [
      rustup
      zlib
      openssl.dev
      pkg-config
      stdenv.cc
      cmake
      mono
      msbuild
    ]
    ++ [ dotnet-stack ]
  );
in
{
  home.packages = with pkgs; [
    dotnet-stack
    dotnet-ef
  ];

  programs.vscode = {
    package =
      (pkgs.vscode.overrideAttrs (prevAttrs: {
        nativeBuildInputs = prevAttrs.nativeBuildInputs ++ [ pkgs.makeWrapper ];
        postFixup =
          prevAttrs.postFixup
          + ''
            wrapProgram $out/bin/code \
              --set DOTNET_ROOT "${dotnet-stack}" \
              --prefix PATH : "~/.dotnet/tools"
          '';
      })).fhsWithPackages
        (ps: deps ps);
    extensions = [ pkgs.vscode-extensions.sonarsource.sonarlint-vscode ];
  };
}