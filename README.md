# ❄️ nix-config

Personal Nix Flakes config (Home Manager + NixOS + Darwin). `Dendritic pattern`: a single `modules/` tree, auto-imported via [`import-tree`](https://github.com/vic/import-tree) — nothing listed by hand in `flake.nix`.

- `nixpkgs`/`home-manager`/`nix-darwin` track the stable release via FlakeHub; use `pkgs.unstable.<pkg>` for bleeding-edge.

## Prerequisites

- Nix installer:
  - Home Manager / NixOS: [Determinate Nix](https://determinate.systems/blog/determinate-nix-installer/)
  - Darwin: [Lix](https://lix.systems/install/) — nix-darwin's [recommended installer](https://github.com/nix-darwin/nix-darwin/blob/master/README.md), since the official Nix installer lacks an automated uninstaller on macOS
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

Darwin:

```bash
sudo nix run nix-darwin -- switch --flake .#<host>
```

NixOS:

```bash
sudo nixos-generate-config --show-hardware-config > modules/hosts/<host>/_hardware.nix
sudo nixos-rebuild switch --flake .#<host>
```
