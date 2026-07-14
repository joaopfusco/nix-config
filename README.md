# ❄️ nix-config

Configuração pessoal em Nix Flakes, cobrindo dois cenários:

- **`hosts/`** — máquinas onde o NixOS é dono do sistema operacional inteiro. Cada host
  importa `modules/nixos/*` (sistema) e embute o Home Manager como módulo do próprio NixOS
  (um único `nixos-rebuild switch` aplica os dois).
- **`home/`** — perfis standalone do Home Manager, para quando o Nix não é dono do SO
  (qualquer distro Linux não-NixOS, ou macOS sem nix-darwin). Aplicados via
  `home-manager switch`, sem tocar no sistema.

Os dois lados compartilham os mesmos módulos de usuário (`modules/home/*`).

## Estrutura

```
nix-config/
├── flake.nix
├── hosts/                    # máquinas NixOS
│   └── <nome-do-host>/
│       ├── configuration.nix
│       ├── hardware-configuration.nix
│       └── home.nix
├── home/                     # perfis standalone (só Home Manager)
│   └── <perfil>/home.nix     # ex.: qualquer distro Linux não-NixOS, macOS sem nix-darwin
└── modules/
    ├── nixos/                # módulos de sistema — só existem dentro de um host NixOS
    │   └── <assunto>.nix     # um arquivo por concern (rede, locale, hardware, etc.)
    └── home/                 # módulos de usuário — compartilhados por hosts/ e home/
        └── <app>/            # um módulo por app/ferramenta (ver convenção abaixo)
```

Os nomes de host/perfil correspondem 1:1 aos nomes das pastas em `hosts/` e `home/`
(descobertos automaticamente pelo `flake.nix` — não precisam ser listados em lugar nenhum).

### Convenção `config/` + `default.nix`

Cada módulo de `modules/home/<app>/` que instala um app **e** gerencia a config dele segue o
mesmo padrão:

- `config/` — só a configuração (`programs.<app>.package = lib.mkDefault pkgs.emptyDirectory;`
  — ou `null`, quando o módulo aceita). O binário não vem do Nix; instale como preferir
  (apt, brew, etc.) e o Home Manager só escreve os dotfiles.
- `default.nix` — importa `./config` e sobrescreve o `package` pelo pacote real do Nix. Variante
  "completa": instala e configura.

Cada `home.nix` escolhe, módulo por módulo, qual variante importar
(`../../modules/home/<app>` vs `../../modules/home/<app>/config`). Nos hosts NixOS isso não
faz tanta diferença (lá o Nix já é dono do sistema todo, então normalmente vale a pena usar
sempre a variante completa); nos perfis standalone é onde essa escolha importa de verdade.

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

### Máquina NixOS (`hosts/<nome>`)

1. Instale o NixOS normalmente (boot no ISO, particiona, `nixos-generate-config`).
2. Copie o `hardware-configuration.nix` gerado pra `hosts/<nome>/hardware-configuration.nix`
   (sobrescrevendo o placeholder, se for um host novo).
3. Aplique:
   ```bash
   sudo nixos-rebuild switch --flake .#<nome-do-host>
   ```

### Linux não-NixOS ou macOS sem nix-darwin (`home/<perfil>`)

```bash
home-manager switch --flake .#joaop@<perfil>
```

## Dia a dia

```bash
# Atualizar os inputs do flake (nixpkgs estável avança sozinho; revise o diff do flake.lock)
nix flake update

# Reaplicar — máquina NixOS
sudo nixos-rebuild switch --flake .#<nome-do-host>

# Reaplicar — perfil standalone
home-manager switch --flake .#joaop@<perfil>
```
