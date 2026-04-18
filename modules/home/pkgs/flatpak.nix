{ inputs, pkgs, ... }:

{
  imports = [
    inputs.nix-flatpak.homeManagerModules.nix-flatpak
  ];

  services.flatpak = {
    enable = true;

    remotes = [
      {
        name = "flathub-user";
        location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
      }
    ];

    packages = [
      { appId = "com.github.tchx84.Flatseal"; origin = "flathub-user"; }
      { appId = "io.github.flattool.Warehouse"; origin = "flathub-user"; }
    ];

    uninstallUnmanaged = true;
  };
}