# ❄️ nix-config

Configuração pessoal em Nix Flakes, usando **Home Manager standalone** (Nix não é dono
do sistema operacional — funciona em qualquer distro Linux ou macOS).

## Estrutura

```
nix-config/
├── flake.nix
├── home/                      # perfis standalone
│   └── <perfil>/home.nix      # ex.: linux, macos
└── modules/                   # módulos de usuário, compartilhados por todos os perfis
    └── <app>/                 # um módulo por app/ferramenta (ver convenção abaixo)
```

Os nomes de perfil correspondem 1:1 aos nomes das pastas em `home/`
(descobertos automaticamente pelo `flake.nix` — não precisam ser listados em lugar nenhum).

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

Módulos que são só uma lista de pacotes, sem config nenhuma pra separar, não têm `config/` —
só um `default.nix` direto.

### Canais do nixpkgs

`nixpkgs` (padrão, `pkgs.<pkg>`) e `home-manager` apontam pro **release estável mais recente**
via FlakeHub (`https://flakehub.com/f/.../0`) — esse range é flutuante, então `nix flake update`
avança sozinho a cada novo release sem precisar editar a URL. Pra algo bleeding-edge específico,
use `pkgs.unstable.<pkg>` (`nixpkgs-unstable`, `nixos-unstable`).

## Pré-requisitos

- **Nix** instalado (recomendado: [Determinate Nix](https://install.determinate.systems)).
- **Git** configurado.

```bash
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
nix flake update

# Reaplicar
home-manager switch --flake .#joaop@<perfil>
```
