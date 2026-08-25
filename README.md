# ❄️ nix-config

Personal Nix Flakes config (Home Manager + NixOS). `Dendritic pattern`: a single `modules/` tree, auto-imported via [`import-tree`](https://github.com/vic/import-tree) — nothing listed by hand in `flake.nix`.

- `nixpkgs`/`home-manager` track the stable release; use `pkgs.unstable.<pkg>` for bleeding-edge.

## Prerequisites

- Nix installer: [Determinate Nix](https://determinate.systems/blog/determinate-nix-installer/) or [Lix](https://lix.systems/install/)
- Git configured, with an SSH key registered on GitHub

```bash
ssh-keygen -t ed25519 -C "joaopedrofusco@gmail.com"
cat ~/.ssh/id_ed25519.pub # copy this to GitHub
```

```bash
nix-shell -p git
git clone git@github.com:joaopfusco/nix-config.git
cd nix-config
```

## Initial setup

Home Manager:

```bash
nix run home-manager -- switch --flake .#joaop@<host>
```

NixOS:

```bash
sudo nixos-generate-config --show-hardware-config > modules/hosts/<host>/_hardware.nix
sudo nixos-rebuild switch --flake .#<host>
```

## Uninstalling

[Determinate Nix](https://manual.determinate.systems/installation/uninstall):

```bash
sudo /nix/nix-installer uninstall
```

[Lix](https://lix.systems/install/):

```bash
sudo /nix/lix-installer uninstall
```
