# ❄️ nix-config

Personal Nix Flakes config (Home Manager + NixOS). `Dendritic pattern`: a single
`modules/` tree, auto-imported via [`import-tree`](https://github.com/vic/import-tree) — nothing listed by hand in `flake.nix`.

## Structure

```
nix-config/
├── flake.nix
└── modules/
    ├── flake/           # nixpkgs/overlays, systems, treefmt, `host.*` option
    ├── home-manager/    # user modules (1 per app)
    │   └── <app>/       # when it has its own dotfile
    ├── nixos/           # system modules (1 per concern)
    └── hosts/<host>/
        ├── default.nix    # nixosConfigurations.<host> or homeConfigurations."<username>@<host>"
        └── _hardware.nix  # (NixOS) nixos-generate-config output
```

- **NixOS** (`precision-7540`, `virtual-machine`): Nix owns the system, Home Manager plugged in as a NixOS module.
- **Home Manager standalone** (`notebook`, `macbook`): Nix doesn't own the OS.
- Dotfiles symlink straight from the repo (`mkOutOfStoreSymlink`) — edits apply live, no switch needed.
- `nixpkgs`/`home-manager` track the stable release via FlakeHub; use `pkgs.unstable.<pkg>` for bleeding-edge.

## Prerequisites

- [Determinate Nix](https://install.determinate.systems)
- Git configured, with an SSH key registered on GitHub

```bash
nix-shell -p git home-manager
git clone git@github.com:joaopfusco/nix-config.git
cd nix-config
```

## Initial setup

Home Manager standalone:

```bash
home-manager switch --flake .#joaop@<profile>
```

NixOS — generate hardware config before the first switch:

```bash
sudo nixos-generate-config --show-hardware-config > modules/hosts/<host>/_hardware.nix
sudo nixos-rebuild switch --flake .#<host>
```

## Daily use

Aliases in `modules/home-manager/aliases.nix` (assume repo at `~/nix-config`):

```bash
# Home Manager
home-sync      # pull + home-switch
home-switch    # nix fmt + home-manager switch
home-upgrade   # pull + flake update + home-switch
home-test      # dry-run
home-gens      # generations
home-rollback  # previous generation

# NixOS
nixos-sync      # pull + nixos-switch
nixos-switch    # nix fmt + nixos-rebuild switch
nixos-upgrade   # pull + flake update + nixos-switch
nixos-test      # nixos-rebuild test
nixos-gens      # generations
nixos-rollback  # nixos-rebuild switch --rollback
```
