# ❄️ nix-config

Config pessoal em Nix Flakes (Home Manager + NixOS). Estilo dendrítico: um único
`modules/` auto-importado via [`import-tree`](https://github.com/vic/import-tree) —
nada é listado à mão em `flake.nix`.

## Estrutura

```
nix-config/
├── flake.nix
└── modules/
    ├── flake/          # nixpkgs/overlays, systems, treefmt, opção `host.*`
    ├── home-manager/    # módulos de usuário (1 por app)
    │   └── <app>/       # quando tem dotfile próprio
    ├── nixos/           # módulos de sistema (1 por preocupação)
    └── hosts/<host>/
        ├── default.nix  # nixosConfigurations.<host> ou homeConfigurations."joaop@<host>"
        └── _hardware.nix  # (NixOS) saída do nixos-generate-config
```

Cada módulo se registra em `flake.modules.nixos.<nome>` /
`flake.modules.homeManager.<nome>`; o `default.nix` do host escolhe quais compor.

- **NixOS** (`precision-7540`, `virtual-machine`): Nix dono do sistema, Home Manager
  plugado como módulo NixOS.
- **Home Manager standalone** (`notebook`, `macbook`): Nix não dono do SO.

Módulo é **arquivo solto** por padrão; vira **pasta** só quando tem dotfile pra
symlinkar. Dotfile symlinka direto do repo (`mkOutOfStoreSymlink`), não usa opção
tipada — editar o arquivo reflete na hora, sem switch. Quando o app é instalado por
fora (apt/brew), o host sobrescreve `programs.<app>.package = lib.mkForce null`.

`nixpkgs`/`home-manager` seguem o release estável via FlakeHub (avança sozinho no
`nix flake update`). Pra bleeding-edge, `pkgs.unstable.<pkg>`.

## Pré-requisitos

- [Determinate Nix](https://install.determinate.systems)
- Git configurado
- Chave SSH cadastrada no GitHub:

```bash
ssh-keygen -t ed25519 -C "joaopedrofusco@gmail.com"
cat ~/.ssh/id_ed25519.pub  # cadastrar em github.com/settings/keys
```

```bash
nix-shell -p git home-manager
git clone git@github.com:joaopfusco/nix-config.git
cd nix-config
```

## Setup inicial

Home Manager standalone:

```bash
home-manager switch --flake .#joaop@<perfil>
```

NixOS — gerar hardware do host antes do primeiro switch:

```bash
sudo nixos-generate-config --show-hardware-config > modules/hosts/<host>/_hardware.nix
sudo nixos-rebuild switch --flake .#<host>
```

## Dia a dia

Aliases em `modules/home-manager/aliases.nix` (assumem repo em `~/nix-config`):

```bash
# Home Manager
home-sync      # pull + home-switch
home-switch    # nix fmt + home-manager switch
home-upgrade   # pull + flake update + home-switch
home-test      # dry-run
home-gens      # gerações
home-rollback  # geração anterior

# NixOS
nixos-sync      # pull + nixos-switch
nixos-switch    # nix fmt + nixos-rebuild switch
nixos-upgrade   # pull + flake update + nixos-switch
nixos-test      # nixos-rebuild test
nixos-gens      # gerações
nixos-rollback  # nixos-rebuild switch --rollback
```
