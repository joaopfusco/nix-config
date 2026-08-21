{
  flake.modules.homeManager.nix = { lib, pkgs, ... }: {
    nix.package = lib.mkDefault pkgs.nix;
    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };
}
