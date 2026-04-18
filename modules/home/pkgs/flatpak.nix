{ inputs, ... }:

{
  imports = [
    inputs.nix-flatpak.homeManagerModules.nix-flatpak
  ];

  services.flatpak = {
    enable = true;

    remotes = [
      {
        name = "flathub";
        location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
      }
    ];

    packages = [
      { appId = "com.github.tchx84.Flatseal"; origin = "flathub"; }
      { appId = "io.github.flattool.Warehouse"; origin = "flathub"; }
    ];

    uninstallUnmanaged = true;
  };
}