{
  flake.modules.nixos.nix = {
    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
    nix.optimise.automatic = true;
    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };
}
