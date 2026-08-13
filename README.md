# ❄️ nix-config

Personal Nix Flakes config (Home Manager + NixOS). `Dendritic pattern`: a single `modules/` tree, auto-imported via [`import-tree`](https://github.com/vic/import-tree) — nothing listed by hand in `flake.nix`.

- `nixpkgs`/`home-manager` track the stable release via FlakeHub; use `pkgs.unstable.<pkg>` for bleeding-edge.

## Prerequisites

- [Determinate Nix](https://install.determinate.systems)
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

Home Manager standalone:

```bash
nix-shell -p home-manager
home-manager switch --flake .#joaop@<host>
```

NixOS — generate hardware config before the first switch:

```bash
sudo nixos-generate-config --show-hardware-config > modules/hosts/<host>/_hardware.nix
sudo nixos-rebuild switch --flake .#<host>
```
