{ pkgs, ... }:

let
  # Not recommended, but some apps require --no-sandbox to work via nix
  # Usage: wrapSandbox postman
  wrapSandbox = pkg: pkgs.symlinkJoin {
    name = "${pkg.pname}-no-sandbox";
    paths = [ pkg ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/${pkg.pname} \
        --add-flags "--no-sandbox"
    '';
  };
in
{
  home.packages = with pkgs; [
    dbeaver-bin
    obs-studio
    alacarte
  ];
}