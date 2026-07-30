# ❄️ nix-config

Configuração pessoal em Nix Flakes, usando **Home Manager standalone** (Nix não é dono
do sistema operacional — funciona em qualquer distro Linux ou macOS).

## Estrutura

```
nix-config/
├── flake.nix
├── hosts/                     # perfis standalone
│   └── <perfil>/home.nix      # ex.: linux, macos
└── modules/                   # módulos de usuário, compartilhados por todos os perfis
    ├── <app>.nix              # módulo sem config própria pra separar (ver convenção abaixo)
    └── <app>/                 # módulo com config/ própria (ver convenção abaixo)
```

Os nomes de perfil correspondem 1:1 aos nomes das pastas em `hosts/`
(descobertos automaticamente pelo `flake.nix` — não precisam ser listados em lugar nenhum).

### Arquivo solto vs. pasta

Módulo vira **arquivo solto** (`modules/<app>.nix`) por padrão — é o caso comum: só
`home.packages` e/ou `programs.<app>.enable`/settings simples, sem nenhum arquivo
companheiro. Só vira **pasta** (`modules/<app>/`) quando há motivo de verdade: dotfile
próprio pra symlinkar (`config/settings.json`, `config/keymap.json`, hooks, etc.) ou a
separação `config/` + `default.nix` abaixo.

### Convenção `config/` + `default.nix`

Cada módulo de `modules/<app>/` que instala um app **e** gerencia a config dele segue o
mesmo padrão:

- `config/` — só a configuração (`programs.<app>.package = lib.mkDefault pkgs.emptyDirectory;`
  — ou `null`, quando o módulo aceita). O binário não vem do Nix; instale como preferir
  (apt, brew, etc.) e o Home Manager só escreve os dotfiles.
- `default.nix` — importa `./config` e sobrescreve o `package` pelo pacote real do Nix. Variante
  "completa": instala e configura.

Cada `home.nix` escolhe, módulo por módulo, qual variante importar
(`../../modules/<app>` vs `../../modules/<app>/config`).

### Canais do nixpkgs

`nixpkgs` (padrão, `pkgs.<pkg>`) e `home-manager` apontam pro **release estável mais recente**
via FlakeHub (`https://flakehub.com/f/.../0`) — esse range é flutuante, então `nix flake update`
avança sozinho a cada novo release sem precisar editar a URL. Pra algo bleeding-edge específico,
use `pkgs.unstable.<pkg>` (`nixpkgs-unstable`, `nixos-unstable`).

## Pré-requisitos

- **Nix** instalado (recomendado: [Determinate Nix](https://install.determinate.systems)).
- **Git** configurado.
- **Chave SSH** cadastrada no GitHub (necessária pra clonar via `git@github.com`):

```bash
ssh-keygen -t ed25519 -C "joaopedrofusco@gmail.com"
cat ~/.ssh/id_ed25519.pub
```

Copie a saída do `cat` e cadastre em
[github.com/settings/keys](https://github.com/settings/keys) → "New SSH key".

```bash
nix-shell -p git home-manager
git clone git@github.com:joaopfusco/nix-config.git
cd nix-config
```

## Setup inicial (nova instalação)

```bash
home-manager switch --flake .#joaop@<perfil>
```

## Dia a dia

```bash
# Atualizar os inputs do flake (nixpkgs estável avança sozinho; revise o diff do flake.lock)
home-upgrade

# Reaplicar
home-switch
```
