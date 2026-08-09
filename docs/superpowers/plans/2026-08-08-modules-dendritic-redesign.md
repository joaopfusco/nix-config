# Redesenho flake-parts + dendritic pattern — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Reorganizar `nix-config` de `home-manager/` + `nixos/` + `lib/` (módulos inconsistentes, hosts escolhidos por import path) pra uma árvore única `modules/` em flake-parts + dendritic pattern (`import-tree`), com `host.*` namespace, toggle por presença seletiva no `imports` do host, e pacote-vs-nativo resolvido sobrescrevendo a opção real do próprio módulo (`lib.mkForce null`), nunca por import de variante.

**Architecture:** `flake.nix` vira só inputs + `flake-parts.lib.mkFlake` + `import-tree ./modules`. Cada arquivo em `modules/` contribui `flake.modules.<nixos|homeManager>.<nome>` (namespace do flake-parts, plugin `flakeModules.modules`). Hosts (`modules/hosts/nixos/<host>/`, `modules/hosts/home-manager/<perfil>.nix`) listam explicitamente quais nomes usam e sobrescrevem `programs.<app>.package`/opções customizadas pontualmente.

**Tech Stack:** Nix Flakes, flake-parts, home-manager, nixos-hardware, `vic/import-tree`.

## Global Constraints

- Spec de referência: `docs/superpowers/specs/2026-08-08-modules-dendritic-redesign-design.md` — qualquer dúvida de convenção, essa é a fonte.
- **Sem opção `enable` inventada.** Feature liga por estar listada no `modules = [...]` do host (seção 4 da spec).
- **Sem hjem, sem dois módulos nomeados por app** (`kitty`/`kitty-dotfiles`). Um único aspecto por app; pacote-vs-nativo é o host sobrescrevendo `programs.<app>.package = lib.mkForce null;` (ou uma opção custom equivalente quando o app não tem `programs.<app>` nativo — ex. `dotnetSdks`) — nunca escolha de import (seção 5).
- **Arquivo solto por padrão.** Pasta só por asset cru companheiro OU agrupamento de `.nix` irmãos do mesmo assunto — nunca pra um único arquivo sem asset (seção 6).
- **Nome de arquivo em kebab-case; nome do atributo do módulo (`flake.modules.<classe>.<nome>`) no mesmo texto convertido pra camelCase** — ex. arquivo `nix-settings.nix` → atributo `nixSettings`; arquivo `zed-editor/` → atributo `zedEditor`. Aplicado em todo o plano, sem exceção.
- **Sem mudança de comportamento.** A matriz de "quem usa o quê" abaixo é a atual, verificada por grep no repo antes de escrever este plano — reproduzir exatamente, não "melhorar" nada:

  | App | precision-7540 (NixOS) | virtual-machine (NixOS) | notebook (HM standalone, real) | macbook (HM standalone) |
  |---|---|---|---|---|
  | gh, git, direnv, nodejs, python, cli-tools, zsh, starship | completo | completo | completo | completo |
  | dotnet | só `dotnet-ef` (sem FHS envs) | completo (FHS envs) | só `dotnet-ef` | só `dotnet-ef` |
  | claude-code | completo | completo | config-only | config-only |
  | zed-editor | completo | completo | config-only | config-only |
  | kitty | completo | completo | config-only | config-only |
  | flameshot | não usado | completo | não usado | não usado |
  | copyq | não usado | completo | não usado | não usado |
  | distrobox-export | não usado em lugar nenhum hoje (módulo órfão) — migrar disponível, sem anexar a nenhum host |

- **`notebook` é o perfil real, aplicado na máquina principal — migra por último**, só depois de todo o resto (`nix flake check` limpo + `nix build` a seco dos outros 3 hosts). Rodar `home-manager switch`/`nixos-rebuild switch` de verdade é decisão do usuário, não deste plano — nenhum task executa switch.
- Verificação padrão de cada task: `nix flake check` (framework/módulos) e, pra tasks de host, também `nix build .#nixosConfigurations.<host>.config.system.build.toplevel --dry-run` (NixOS) ou `nix build '.#homeConfigurations."joaop@<perfil>".activationPackage' --dry-run` (standalone).
- Nada de `git rm -rf` das pastas antigas até a última task (cleanup) — durante a migração elas ficam paradas, sem uso, mas presentes (reversível).

---

## File Structure

```
modules/
├── nix/{flake-parts,nixpkgs,host-options,home-manager}.nix
├── programs/
│   ├── git.nix, direnv.nix, gh.nix, cli-tools.nix, nodejs.nix, python.nix
│   ├── dotnet.nix, kitty.nix, copyq.nix, flameshot.nix
│   ├── zsh/{default,aliases,init-content,oh-my-zsh}.nix
│   ├── starship/{default.nix,starship.toml}
│   ├── zed-editor/{default.nix,settings.json,keymap.json}
│   ├── claude-code/{default.nix,CLAUDE.md,settings.json,hooks/,rules/,references/,skills/}
│   └── distrobox-export/{default.nix,sync-exports.sh}
├── services/{docker,flatpak,distrobox}.nix
├── system/
│   ├── locale.nix, networking.nix, nix-settings.nix, nix-ld.nix, user.nix, vm-guest.nix
│   ├── boot/{systemd-boot,grub,inotify}.nix
│   ├── desktop/{gnome,plasma}.nix
│   ├── hardware/{common,intel,nvidia,audio}.nix
│   └── pkgs/{cli,gui,media-codecs}.nix
└── hosts/
    ├── nixos/{precision-7540,virtual-machine}/{default.nix,hardware-configuration.nix}
    └── home-manager/{notebook,macbook}.nix
```

---

### Task 1: Fundação flake-parts (flake.nix + nixpkgs)

**Files:**
- Modify: `flake.nix`
- Create: `modules/nix/flake-parts.nix`
- Create: `modules/nix/nixpkgs.nix`

**Interfaces:**
- Produces: `systems`, `perSystem._module.args.pkgs`, `legacyPackages.<system>` (output `nix shell pkgs#<pkg>` continua funcionando), namespace `flake.modules.<classe>.<nome>` disponível pra todo módulo seguinte.

- [ ] **Step 1: Reescrever `flake.nix`**

```nix
{
  description = "Nix Configuration";

  inputs = {
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "https://flakehub.com/f/nix-community/home-manager/0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware = {
      url = "github:nixos/nixos-hardware";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";
  };

  outputs =
    inputs@{ flake-parts, import-tree, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ (import-tree ./modules) ];
    };
}
```

- [ ] **Step 2: Criar `modules/nix/flake-parts.nix`**

```nix
{ inputs, lib, ... }:
{
  imports = [ inputs.flake-parts.flakeModules.modules ];

  options.flake.homeConfigurations = lib.mkOption {
    type = lib.types.lazyAttrsOf lib.types.raw;
    default = { };
  };

  options.flake.nixosConfigurations = lib.mkOption {
    type = lib.types.lazyAttrsOf lib.types.raw;
    default = { };
  };
}
```

- [ ] **Step 3: Criar `modules/nix/nixpkgs.nix`**

```nix
{ inputs, ... }:
let
  overlays = [
    (final: prev: {
      unstable = import inputs.nixpkgs-unstable {
        system = final.stdenv.hostPlatform.system;
        config.allowUnfree = true;
      };
    })
  ];
  mkPkgs = system: import inputs.nixpkgs { inherit system overlays; config.allowUnfree = true; };
in
{
  systems = [
    "x86_64-linux"
    "aarch64-linux"
    "aarch64-darwin"
    "x86_64-darwin"
  ];

  perSystem = { system, ... }: {
    _module.args.pkgs = mkPkgs system;
    legacyPackages = mkPkgs system;
  };
}
```

- [ ] **Step 4: Verificar**

Run: `nix flake check`
Expected: passa sem erro (ainda não há `nixosConfigurations`/`homeConfigurations` nenhuma, só a fundação).

- [ ] **Step 5: Commit**

```bash
git add flake.nix modules/nix/flake-parts.nix modules/nix/nixpkgs.nix
git commit -m "feat(flake): adopt flake-parts + import-tree foundation"
```

---

### Task 2: `host.*` + wiring do home-manager

**Files:**
- Create: `modules/nix/host-options.nix`
- Create: `modules/nix/home-manager.nix`

**Interfaces:**
- Consumes: `flake.modules.nixos.base` / `flake.modules.homeManager.base` (namespace do Task 1).
- Produces: `config.host.{name,user.name,system,state.version,isNixOS,isHomeManager}` disponível em qualquer módulo NixOS/HM que inclua `base`; `flake.modules.homeManager.base` traz `home.username`, `home.homeDirectory`, `home.stateVersion`, `nix.registry.pkgs.flake`, `news.display`, e (quando standalone, `osConfig == null`) `targets.genericLinux.enable` + `nix.gc`.

- [ ] **Step 1: Criar `modules/nix/host-options.nix`**

```nix
{ lib, ... }:
let
  hostOptions = {
    name = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Nome do host/perfil.";
    };
    user.name = lib.mkOption {
      type = lib.types.str;
      default = "joaop";
      description = "Usuário dono da configuração.";
    };
    system = lib.mkOption {
      type = lib.types.str;
      default = "x86_64-linux";
      description = "Arquitetura do sistema.";
    };
    state.version = lib.mkOption {
      type = lib.types.str;
      default = "26.05";
      description = "stateVersion do NixOS/Home Manager.";
    };
    isNixOS = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
    isHomeManager = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };
in
{
  flake.modules.nixos.base = {
    options.host = hostOptions;
    config.host.isNixOS = lib.mkDefault true;
  };

  flake.modules.homeManager.base = {
    options.host = hostOptions;
    config.host.isHomeManager = lib.mkDefault true;
  };
}
```

- [ ] **Step 2: Criar `modules/nix/home-manager.nix`**

```nix
{ inputs, ... }:
{
  flake.modules.nixos.base =
    { config, ... }:
    {
      imports = [ inputs.home-manager.nixosModules.home-manager ];

      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs = { inherit inputs; };
      };
    };

  flake.modules.homeManager.base =
    { config, pkgs, osConfig, ... }:
    {
      config = lib.mkMerge [
        {
          nix.registry.pkgs.flake = inputs.self;
          news.display = "silent";
          home = {
            username = config.host.user.name;
            homeDirectory =
              if pkgs.stdenv.hostPlatform.isLinux then
                "/home/${config.host.user.name}"
              else
                "/Users/${config.host.user.name}";
            stateVersion = config.host.state.version;
            sessionVariables.NIX_PATH = "nixpkgs=${pkgs.path}";
          };
        }
        (lib.mkIf (osConfig == null) {
          targets.genericLinux.enable = pkgs.stdenv.hostPlatform.isLinux;
          nix.gc = {
            automatic = true;
            dates = "weekly";
            options = "--delete-older-than 7d";
          };
        })
      ];
    };
}
```

**Nota:** falta `lib` nos argumentos da função de `flake.modules.homeManager.base` acima — corrigir pra
`{ config, lib, pkgs, osConfig, ... }:` antes de rodar (usa `lib.mkMerge`/`lib.mkIf`).

- [ ] **Step 3: Corrigir a assinatura da função (aplicar a nota acima)**

Editar a primeira linha do `flake.modules.homeManager.base` de `home-manager.nix` pra:
```nix
  flake.modules.homeManager.base =
    { config, lib, pkgs, osConfig, ... }:
```

- [ ] **Step 4: Verificar**

Run: `nix flake check`
Expected: passa sem erro.

- [ ] **Step 5: Commit**

```bash
git add modules/nix/host-options.nix modules/nix/home-manager.nix
git commit -m "feat(flake): add host.* namespace and home-manager wiring"
```

---

### Task 3: Módulos de sistema NixOS — base/boot/desktop/hardware

**Files:**
- Create: `modules/system/locale.nix`, `modules/system/networking.nix`, `modules/system/nix-settings.nix`, `modules/system/nix-ld.nix`, `modules/system/user.nix`
- Create: `modules/system/boot/systemd-boot.nix`, `modules/system/boot/grub.nix`, `modules/system/boot/inotify.nix`
- Create: `modules/system/desktop/gnome.nix`, `modules/system/desktop/plasma.nix`
- Create: `modules/system/hardware/common.nix`, `modules/system/hardware/intel.nix`, `modules/system/hardware/nvidia.nix`, `modules/system/hardware/audio.nix`

**Interfaces:**
- Produces: `flake.modules.nixos.{locale,networking,nixSettings,nixLd,user,systemdBoot,grub,inotify,gnome,plasma,hardwareCommon,intel,nvidia,audio}`.

- [ ] **Step 1: `modules/system/locale.nix`**

```nix
{
  flake.modules.nixos.locale = {
    time.timeZone = "America/Sao_Paulo";

    i18n.defaultLocale = "en_US.UTF-8";
    i18n.extraLocaleSettings = {
      LC_ADDRESS = "pt_BR.UTF-8";
      LC_IDENTIFICATION = "pt_BR.UTF-8";
      LC_MEASUREMENT = "pt_BR.UTF-8";
      LC_MONETARY = "pt_BR.UTF-8";
      LC_NAME = "pt_BR.UTF-8";
      LC_NUMERIC = "pt_BR.UTF-8";
      LC_PAPER = "pt_BR.UTF-8";
      LC_TELEPHONE = "pt_BR.UTF-8";
      LC_TIME = "pt_BR.UTF-8";
    };

    services.xserver.xkb = {
      layout = "us";
      variant = "intl";
    };

    console.keyMap = "us-acentos";
  };
}
```

- [ ] **Step 2: `modules/system/networking.nix`**

```nix
{
  flake.modules.nixos.networking =
    { config, ... }:
    {
      networking.hostName = config.host.name;
      networking.networkmanager.enable = true;
      networking.firewall.enable = true;
    };
}
```

- [ ] **Step 3: `modules/system/nix-settings.nix`**

```nix
{
  flake.modules.nixos.nixSettings = {
    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
    nix.optimise.automatic = true;
    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };
}
```

- [ ] **Step 4: `modules/system/nix-ld.nix`**

```nix
{
  flake.modules.nixos.nixLd =
    { pkgs, ... }:
    {
      programs.nix-ld = {
        enable = true;
        libraries = with pkgs; [
          stdenv.cc.cc
          zlib
          openssl
          libGL
          glib
        ];
      };
    };
}
```

- [ ] **Step 5: `modules/system/user.nix`**

```nix
{
  flake.modules.nixos.user =
    { config, pkgs, ... }:
    {
      programs.zsh.enable = true;

      users.users.${config.host.user.name} = {
        shell = pkgs.zsh;
        isNormalUser = true;
        description = "Joao Pedro Fusco";
        extraGroups = [
          "networkmanager"
          "wheel"
          "docker"
          "libvirtd"
          "kvm"
          "dialout"
        ];
      };
    };
}
```

- [ ] **Step 6: `modules/system/boot/systemd-boot.nix`**

```nix
{
  flake.modules.nixos.systemdBoot = {
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
  };
}
```

- [ ] **Step 7: `modules/system/boot/grub.nix`**

Conteúdo real do `nixos/modules/boot/grub.nix` não foi lido durante a pesquisa —
**antes de escrever este arquivo, ler `nixos/modules/boot/grub.nix` no repo atual e
copiar o conteúdo verbatim**, só trocando o wrapper pra
`flake.modules.nixos.grub = { ... conteúdo original ... };`.

- [ ] **Step 8: `modules/system/boot/inotify.nix`**

```nix
{
  flake.modules.nixos.inotify = {
    boot.kernel.sysctl = {
      "fs.inotify.max_user_watches" = 524288;
      "fs.inotify.max_user_instances" = 512;
    };
  };
}
```

- [ ] **Step 9: `modules/system/desktop/gnome.nix`**

```nix
{
  flake.modules.nixos.gnome =
    { pkgs, ... }:
    {
      services.xserver.enable = true;
      services.displayManager.gdm.enable = true;
      services.desktopManager.gnome.enable = true;
      environment.sessionVariables.NIXOS_OZONE_WL = "1";

      environment.systemPackages = with pkgs; [
        gnome-tweaks
        gnome-extension-manager
        gnomeExtensions.clipboard-indicator
        gnomeExtensions.appindicator
        gnome-network-displays
        distroshelf
      ];
    };
}
```

- [ ] **Step 10: `modules/system/desktop/plasma.nix`**

Conteúdo real do `nixos/modules/desktop/plasma.nix` não foi lido — **ler o arquivo
original no repo antes de escrever**, copiar verbatim sob
`flake.modules.nixos.plasma = { ... };`.

- [ ] **Step 11: `modules/system/hardware/common.nix`**

```nix
{
  flake.modules.nixos.hardwareCommon = {
    hardware.enableAllFirmware = true;
    hardware.enableRedistributableFirmware = true;
    hardware.bluetooth.enable = true;
    hardware.bluetooth.powerOnBoot = true;
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
    services.fwupd.enable = true;
    services.libinput.enable = true;
    services.libinput.touchpad.tapping = true;
    services.libinput.touchpad.naturalScrolling = true;
    services.printing.enable = true;
  };
}
```

- [ ] **Step 12: `modules/system/hardware/intel.nix`**

```nix
{
  flake.modules.nixos.intel = {
    services.thermald.enable = true;
  };
}
```

- [ ] **Step 13: `modules/system/hardware/nvidia.nix`**

```nix
{
  flake.modules.nixos.nvidia = {
    hardware.nvidia = {
      nvidiaSettings = true;
      modesetting.enable = true;

      # PCI bus IDs confirmados via `lspci -nn | grep -E "VGA|3D"` no precision-7540:
      #   00:02.0 Intel UHD Graphics 630   -> PCI:0:2:0
      #   01:00.0 NVIDIA Quadro RTX 3000   -> PCI:1:0:0
      prime = {
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };
  };
}
```

- [ ] **Step 14: `modules/system/hardware/audio.nix`**

```nix
{
  flake.modules.nixos.audio = {
    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };
}
```

- [ ] **Step 15: Verificar**

Run: `nix flake check`
Expected: passa sem erro.

- [ ] **Step 16: Commit**

```bash
git add modules/system
git commit -m "feat(nixos): migrate system modules (boot, desktop, hardware, locale, networking, user, nix)"
```

---

### Task 4: Pacotes de sistema + serviços

**Files:**
- Create: `modules/system/pkgs/cli.nix`, `modules/system/pkgs/gui.nix`, `modules/system/pkgs/media-codecs.nix`
- Create: `modules/system/vm-guest.nix`
- Create: `modules/services/docker.nix`, `modules/services/flatpak.nix`, `modules/services/distrobox.nix`

**Interfaces:**
- Produces: `flake.modules.nixos.{cliPkgs,guiPkgs,mediaCodecs,vmGuest,docker,flatpak,distrobox}`.

- [ ] **Step 1: `modules/system/pkgs/cli.nix`**

```nix
{
  flake.modules.nixos.cliPkgs =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        wget
        curl
        btop
      ];
    };
}
```

- [ ] **Step 2: `modules/system/pkgs/gui.nix`**

```nix
{
  flake.modules.nixos.guiPkgs =
    { pkgs, ... }:
    {
      environment.systemPackages =
        (with pkgs; [
          libreoffice
          vlc
          obs-studio
          vscode
          dbeaver-bin
          postman
        ])
        ++ (with pkgs.unstable; [
          google-chrome
        ]);

      programs.firefox = {
        enable = true;
        package = pkgs.unstable.firefox;
      };
    };
}
```

- [ ] **Step 3: `modules/system/pkgs/media-codecs.nix`**

```nix
{
  flake.modules.nixos.mediaCodecs =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        gst_all_1.gstreamer
        gst_all_1.gst-plugins-base
        gst_all_1.gst-plugins-good
        gst_all_1.gst-plugins-bad
        gst_all_1.gst-plugins-ugly
        gst_all_1.gst-libav
      ];
    };
}
```

- [ ] **Step 4: `modules/system/vm-guest.nix`**

```nix
{
  flake.modules.nixos.vmGuest = {
    programs.virt-manager.enable = true;
    virtualisation = {
      libvirtd = {
        enable = true;
        qemu.swtpm.enable = true;
      };
      spiceUSBRedirection.enable = true;
    };
  };
}
```

- [ ] **Step 5: `modules/services/docker.nix`**

```nix
{
  flake.modules.nixos.docker = {
    virtualisation.docker.enable = true;
  };
}
```

- [ ] **Step 6: `modules/services/flatpak.nix`**

```nix
{
  flake.modules.nixos.flatpak = {
    # Só liga o serviço/portal — apps instalados imperativamente (flatpak install).
    # Rodar: flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    services.flatpak.enable = true;
  };
}
```

- [ ] **Step 7: `modules/services/distrobox.nix`**

```nix
{
  flake.modules.nixos.distrobox =
    { pkgs, config, ... }:
    {
      environment.systemPackages = [ pkgs.distrobox ];
      systemd.services.distrobox-ubuntu = {
        description = "Ensure ubuntu distrobox container exists";
        wantedBy = [ "multi-user.target" ];
        after = [ "docker.service" ];
        requires = [ "docker.service" ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          User = config.host.user.name;
          ExecStart = ''
            ${pkgs.distrobox}/bin/distrobox create \
              --name ubuntu \
              --image docker.io/library/ubuntu:latest \
              --init \
              --nvidia \
              --additional-packages "systemd libpam-systemd pipewire-audio-client-libraries" \
              --yes
          '';
        };
      };
    };
}
```

- [ ] **Step 8: Verificar**

Run: `nix flake check`
Expected: passa sem erro.

- [ ] **Step 9: Commit**

```bash
git add modules/system/pkgs modules/system/vm-guest.nix modules/services
git commit -m "feat(nixos): migrate system package bundles and services"
```

---

### Task 5: Programas Home Manager simples (sem asset, sem eixo pacote)

**Files:**
- Create: `modules/programs/git.nix`, `modules/programs/direnv.nix`, `modules/programs/gh.nix`,
  `modules/programs/cli-tools.nix`, `modules/programs/nodejs.nix`, `modules/programs/python.nix`

**Interfaces:**
- Produces: `flake.modules.homeManager.{git,direnv,gh,cliTools,nodejs,python}`.

- [ ] **Step 1: `modules/programs/git.nix`**

```nix
{
  flake.modules.homeManager.git = {
    programs.git = {
      enable = true;
      settings = {
        user = {
          name = "joaopfusco";
          email = "joaopedrofusco@gmail.com";
        };
        alias = {
          discard = "!git restore --staged . && git restore . && git clean -fd";
        };
        credential = {
          helper = "store";
        };
      };
    };
  };
}
```

- [ ] **Step 2: `modules/programs/direnv.nix`**

```nix
{
  flake.modules.homeManager.direnv = {
    programs.direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };
  };
}
```

- [ ] **Step 3: `modules/programs/gh.nix`**

```nix
{
  flake.modules.homeManager.gh = {
    # `gh auth login` gerencia ~/.config/gh/hosts.yml (auth state) em runtime.
    programs.gh = {
      enable = true;
      settings = {
        git_protocol = "ssh";
        prompt = "enabled";
        aliases = {
          co = "pr checkout";
        };
      };
    };
  };
}
```

- [ ] **Step 4: `modules/programs/cli-tools.nix`**

```nix
{
  flake.modules.homeManager.cliTools =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        home-manager
        nixfmt
        nixd
        devenv
        fastfetch
        gnumake
        eza
        azure-cli
        codex
      ];
    };
}
```

- [ ] **Step 5: `modules/programs/nodejs.nix`**

```nix
{
  flake.modules.homeManager.nodejs =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        nodejs_24
        pnpm
      ];
    };
}
```

- [ ] **Step 6: `modules/programs/python.nix`**

```nix
{
  flake.modules.homeManager.python =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        python3
        uv
      ];
    };
}
```

- [ ] **Step 7: Verificar**

Run: `nix flake check`
Expected: passa sem erro.

- [ ] **Step 8: Commit**

```bash
git add modules/programs/git.nix modules/programs/direnv.nix modules/programs/gh.nix modules/programs/cli-tools.nix modules/programs/nodejs.nix modules/programs/python.nix
git commit -m "feat(home-manager): migrate simple always-on program modules"
```

---

### Task 6: módulo `zsh` (pasta — 4 `.nix` irmãos)

**Files:**
- Create: `modules/programs/zsh/default.nix`, `modules/programs/zsh/aliases.nix`,
  `modules/programs/zsh/init-content.nix`, `modules/programs/zsh/oh-my-zsh.nix`

**Interfaces:**
- Produces: `flake.modules.homeManager.zsh`.
- Antes de escrever: **ler o conteúdo atual de `home-manager/modules/zsh/config/{aliases,init-content,oh-my-zsh}.nix`** (não lido integralmente durante a pesquisa deste plano) e copiar verbatim pro novo local, só ajustando o wrapper.

- [ ] **Step 1: `modules/programs/zsh/default.nix`**

```nix
{
  flake.modules.homeManager.zsh =
    { config, pkgs, ... }:
    {
      imports = [
        ./aliases.nix
        ./init-content.nix
        ./oh-my-zsh.nix
      ];

      programs.zsh = {
        enable = true;
        package = pkgs.zsh;
        dotDir = "${config.xdg.configHome}/zsh";
        enableCompletion = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;
      };
    };
}
```

- [ ] **Step 2: `modules/programs/zsh/aliases.nix`, `init-content.nix`, `oh-my-zsh.nix`**

Copiar verbatim de `home-manager/modules/zsh/config/{aliases,init-content,oh-my-zsh}.nix`
(ler cada arquivo antes de copiar — conteúdo não capturado durante a pesquisa).

- [ ] **Step 3: Verificar**

Run: `nix flake check`
Expected: passa sem erro.

- [ ] **Step 4: Commit**

```bash
git add modules/programs/zsh
git commit -m "feat(home-manager): migrate zsh module"
```

---

### Task 7: módulo `starship` (pasta — asset cru)

**Files:**
- Create: `modules/programs/starship/default.nix`
- Copy: `modules/programs/starship/starship.toml` (de `home-manager/modules/starship/config/starship.toml`, sem alteração de conteúdo)

**Interfaces:**
- Produces: `flake.modules.homeManager.starship`.

- [ ] **Step 1: Copiar `starship.toml`**

```bash
cp home-manager/modules/starship/config/starship.toml modules/programs/starship/starship.toml
```

- [ ] **Step 2: `modules/programs/starship/default.nix`**

```nix
{
  flake.modules.homeManager.starship =
    { config, ... }:
    {
      programs.starship = {
        enable = true;
        enableZshIntegration = true;
      };

      xdg.configFile."starship.toml".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-config/modules/programs/starship/starship.toml";
    };
}
```

- [ ] **Step 3: Verificar**

Run: `nix flake check`
Expected: passa sem erro.

- [ ] **Step 4: Commit**

```bash
git add modules/programs/starship
git commit -m "feat(home-manager): migrate starship module"
```

---

### Task 8: módulo `dotnet` (arquivo solto — opção `dotnetSdks` pro eixo pacote)

**Files:**
- Create: `modules/programs/dotnet.nix`

**Interfaces:**
- Produces: `flake.modules.homeManager.dotnet`, opção `dotnetSdks` (lista de pacotes,
  default = os 3 FHS envs + wrapper `dotnet`) que hosts sobrescrevem com
  `lib.mkForce [ ]` quando não querem os SDKs completos via Nix (mantendo só
  `pkgs.dotnet-ef`, igual ao `dotnet/config` de hoje).

- [ ] **Step 1: `modules/programs/dotnet.nix`**

```nix
{
  flake.modules.homeManager.dotnet =
    { config, lib, pkgs, ... }:
    let
      inherit (pkgs) dotnetCorePackages;

      mkDotnet =
        name: sdk:
        if pkgs.stdenv.isLinux then
          pkgs.buildFHSEnv {
            inherit name;

            targetPkgs = pkgs: with pkgs; [
              sdk
              dotnet-ef
              icu
              openssl
              zlib
              curl
              krb5
            ];

            runScript = pkgs.writeShellScript "${name}-entry" ''
              export DOTNET_ROOT=/usr/share/dotnet
              exec /usr/bin/dotnet "$@"
            '';

            extraBuildCommands = ''
              cat > $out/etc/os-release <<'EOF'
              ID=linux
              NAME="Linux"
              PRETTY_NAME="Linux"
              EOF
            '';
          }
        else
          pkgs.runCommand name { } ''
            mkdir -p $out/bin
            ln -s ${sdk}/bin/dotnet $out/bin/${name}
          '';
    in
    {
      options.dotnetSdks = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        default = [
          (mkDotnet "dotnet8" dotnetCorePackages.sdk_8_0)
          (mkDotnet "dotnet9" dotnetCorePackages.sdk_9_0)
          (mkDotnet "dotnet10" dotnetCorePackages.sdk_10_0)
          (pkgs.writeShellScriptBin "dotnet" ''exec dotnet8 "$@"'')
        ];
        description = ''
          SDKs do .NET instalados via Nix (FHS envs pesados). Hosts que não
          querem o Nix dono desses binários sobrescrevem com `lib.mkForce [ ]`
          — o `dotnet-ef` continua instalado de qualquer forma.
        '';
      };

      home.packages = config.dotnetSdks ++ [ pkgs.dotnet-ef ];

      home.sessionPath = [ "${config.home.homeDirectory}/.dotnet/tools" ];

      home.sessionVariables = {
        DOTNET_CLI_TELEMETRY_OPTOUT = "1";
        DOTNET_NOLOGO = "1";
      };
    };
}
```

- [ ] **Step 2: Verificar**

Run: `nix flake check`
Expected: passa sem erro.

- [ ] **Step 3: Commit**

```bash
git add modules/programs/dotnet.nix
git commit -m "feat(home-manager): migrate dotnet module with dotnetSdks override option"
```

---

### Task 9: módulos `kitty`, `copyq`, `flameshot` (arquivo solto)

**Files:**
- Create: `modules/programs/kitty.nix`, `modules/programs/copyq.nix`, `modules/programs/flameshot.nix`

**Interfaces:**
- Produces: `flake.modules.homeManager.{kitty,copyq,flameshot}`. `programs.kitty.package`
  é o ponto de override pro eixo pacote (hosts que querem kitty nativo sobrescrevem
  `programs.kitty.package = lib.mkForce null;` na composição do host — feito nas
  tasks 13-16, não aqui).

- [ ] **Step 1: `modules/programs/kitty.nix`**

```nix
{
  flake.modules.homeManager.kitty =
    { pkgs, ... }:
    {
      programs.kitty = {
        enable = true;
        themeFile = "tokyo_night_night";

        settings = {
          shell = "${pkgs.zsh}/bin/zsh --login";
          shell_integration = "enabled";

          window_padding_width = 4;

          scrollback_lines = 10000;
          confirm_os_window_close = 0;
          strip_trailing_spaces = "smart";

          cursor_shape = "beam";
          cursor_blink_interval = 0;

          enable_audio_bell = "no";
          update_check_interval = 0;
          disable_ligatures = "never";

          input_delay = 3;
          repaint_delay = 10;
        };
      };
    };
}
```

**Nota:** confirmar em `nix repl` (`(import <nixpkgs/nixos> {}).options.home-manager... `
ou lendo o módulo `programs.kitty` do home-manager, já verificado nesta sessão) que
`programs.kitty.package` aceita `null` (`lib.mkPackageOption pkgs "kitty" { nullable = true; }`
— confirmado). Nenhuma mudança necessária aqui; é só o host que sobrescreve depois.

- [ ] **Step 2: `modules/programs/copyq.nix`**

```nix
{
  flake.modules.homeManager.copyq =
    { pkgs, lib, ... }:
    {
      home.packages = with pkgs; [ copyq ];

      # copyq toggle
      systemd.user.services.copyq = {
        Unit = {
          Description = "CopyQ clipboard management daemon";
          After = [ "graphical-session.target" ];
          PartOf = [ "graphical-session.target" ];
        };

        Service = {
          ExecStart = "copyq";
          Restart = "on-failure";
        };

        Install.WantedBy = [ "graphical-session.target" ];
      };

      home.activation.copyqConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        if command -v copyq >/dev/null 2>&1; then
          run copyq config move true
          run copyq config activate_closes true
          run copyq config activate_focuses true
          run copyq config activate_pastes false
        fi
      '';
    };
}
```

- [ ] **Step 3: `modules/programs/flameshot.nix`**

```nix
{
  flake.modules.homeManager.flameshot =
    { pkgs, ... }:
    {
      # sh -c "flameshot gui -p ~/Pictures/Screenshots -c"
      xdg.configFile."flameshot/flameshot.ini".source = (pkgs.formats.ini { }).generate "flameshot.ini" {
        General = {
          contrastOpacity = 188;
          showHelp = false;
          showStartupLaunchMessage = false;
        };
      };

      systemd.user.services.flameshot = {
        Unit = {
          Description = "Flameshot screenshot tool";
          After = [ "graphical-session.target" ];
          PartOf = [ "graphical-session.target" ];
        };

        Service = {
          ExecStart = "flameshot";
          Restart = "on-failure";
        };

        Install.WantedBy = [ "graphical-session.target" ];
      };
    };
}
```

- [ ] **Step 4: Verificar**

Run: `nix flake check`
Expected: passa sem erro.

- [ ] **Step 5: Commit**

```bash
git add modules/programs/kitty.nix modules/programs/copyq.nix modules/programs/flameshot.nix
git commit -m "feat(home-manager): migrate kitty, copyq, flameshot modules"
```

---

### Task 10: módulo `zed-editor` (pasta — 2 assets crus)

**Files:**
- Create: `modules/programs/zed-editor/default.nix`
- Copy: `modules/programs/zed-editor/settings.json`, `modules/programs/zed-editor/keymap.json`
  (de `home-manager/modules/zed-editor/config/{settings,keymap}.json`, sem alteração)

**Interfaces:**
- Produces: `flake.modules.homeManager.zedEditor`. `programs.zed-editor.package` é o
  ponto de override.

- [ ] **Step 1: Copiar os assets**

```bash
cp home-manager/modules/zed-editor/config/settings.json modules/programs/zed-editor/settings.json
cp home-manager/modules/zed-editor/config/keymap.json modules/programs/zed-editor/keymap.json
```

- [ ] **Step 2: `modules/programs/zed-editor/default.nix`**

```nix
{
  flake.modules.homeManager.zedEditor =
    { config, ... }:
    {
      programs.zed-editor.enable = true;

      xdg.configFile."zed/settings.json".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-config/modules/programs/zed-editor/settings.json";
      xdg.configFile."zed/keymap.json".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-config/modules/programs/zed-editor/keymap.json";
    };
}
```

- [ ] **Step 3: Verificar**

Run: `nix flake check`
Expected: passa sem erro.

- [ ] **Step 4: Commit**

```bash
git add modules/programs/zed-editor
git commit -m "feat(home-manager): migrate zed-editor module"
```

---

### Task 11: módulo `claude-code` (pasta — árvore inteira de assets)

**Files:**
- Create: `modules/programs/claude-code/default.nix`
- Copy: toda a árvore `home-manager/modules/claude-code/config/**` pra
  `modules/programs/claude-code/**` (CLAUDE.md, settings.json, hooks/, rules/,
  references/, skills/) — sem alteração de conteúdo.

**Interfaces:**
- Produces: `flake.modules.homeManager.claudeCode`. `programs.claude-code.package` é
  o ponto de override.

- [ ] **Step 1: Copiar a árvore de assets**

```bash
cp -r home-manager/modules/claude-code/config/CLAUDE.md modules/programs/claude-code/CLAUDE.md
cp -r home-manager/modules/claude-code/config/settings.json modules/programs/claude-code/settings.json
cp -r home-manager/modules/claude-code/config/hooks modules/programs/claude-code/hooks
cp -r home-manager/modules/claude-code/config/rules modules/programs/claude-code/rules
cp -r home-manager/modules/claude-code/config/references modules/programs/claude-code/references
cp -r home-manager/modules/claude-code/config/skills modules/programs/claude-code/skills
```

- [ ] **Step 2: `modules/programs/claude-code/default.nix`**

```nix
{
  flake.modules.homeManager.claudeCode =
    { config, pkgs, ... }:
    let
      linkConfig =
        name:
        config.lib.file.mkOutOfStoreSymlink
          "${config.home.homeDirectory}/nix-config/modules/programs/claude-code/${name}";
    in
    {
      programs.claude-code.enable = true;

      home.file = {
        ".claude/CLAUDE.md".source = linkConfig "CLAUDE.md";
        ".claude/settings.json".source = linkConfig "settings.json";
        ".claude/hooks".source = linkConfig "hooks";
        ".claude/rules".source = linkConfig "rules";
        ".claude/skills".source = linkConfig "skills";
        ".claude/references".source = linkConfig "references";
      };

      home.packages = with pkgs; [
        typescript-language-server
        pyright
        rust-analyzer
        gopls
        csharp-ls
      ];
    };
}
```

- [ ] **Step 3: Verificar**

Run: `nix flake check`
Expected: passa sem erro.

- [ ] **Step 4: Commit**

```bash
git add modules/programs/claude-code
git commit -m "feat(home-manager): migrate claude-code module"
```

---

### Task 12: módulo `distrobox-export` (pasta — asset cru, órfão)

**Files:**
- Create: `modules/programs/distrobox-export/default.nix`
- Copy: `modules/programs/distrobox-export/sync-exports.sh`

**Interfaces:**
- Produces: `flake.modules.homeManager.distroboxExport`. **Não é anexado a nenhum
  host nas tasks 13-16** — reproduz o estado órfão atual (módulo existe, ninguém
  importa). Se o usuário quiser usar, é decisão separada, fora deste plano.

- [ ] **Step 1: Copiar o script**

```bash
cp home-manager/modules/distrobox-export/sync-exports.sh modules/programs/distrobox-export/sync-exports.sh
```

- [ ] **Step 2: `modules/programs/distrobox-export/default.nix`**

```nix
{
  flake.modules.homeManager.distroboxExport =
    { config, lib, ... }:
    let
      scriptPath = "${config.home.homeDirectory}/.local/bin/sync-exports.sh";
    in
    {
      home.file.".local/bin/sync-exports.sh" = {
        source = ./sync-exports.sh;
        executable = true;
      };

      home.activation.exportToDistrobox = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        DRY_RUN_CMD="$DRY_RUN_CMD" ${scriptPath}
      '';

      systemd.user.paths.distrobox-export-sync = {
        Unit.Description = "Watch ~/.nix-profile/bin for distrobox-export sync";
        Path.PathChanged = "%h/.nix-profile/bin";
        Install.WantedBy = [ "default.target" ];
      };

      systemd.user.services.distrobox-export-sync = {
        Unit.Description = "Sync ~/.nix-profile/bin into distrobox-export";
        Service = {
          Type = "oneshot";
          ExecStart = scriptPath;
        };
      };
    };
}
```

- [ ] **Step 3: Verificar**

Run: `nix flake check`
Expected: passa sem erro.

- [ ] **Step 4: Commit**

```bash
git add modules/programs/distrobox-export
git commit -m "feat(home-manager): migrate distrobox-export module (unattached, matches current orphan state)"
```

---

### Task 13: Host NixOS — `virtual-machine`

**Files:**
- Create: `modules/hosts/nixos/virtual-machine/default.nix`
- Copy: `modules/hosts/nixos/virtual-machine/hardware-configuration.nix`
  (de `nixos/hosts/virtual-machine/hardware-configuration.nix`, sem alteração)

**Interfaces:**
- Consumes: todos os `flake.modules.nixos.*` das tasks 1-4 e todos os
  `flake.modules.homeManager.*` das tasks 2, 5-12.
- Produces: `flake.nixosConfigurations.virtual-machine`.

Matriz (ver Global Constraints): completo em tudo, inclusive `flameshot` e `copyq`,
inclusive `dotnet` completo (com FHS envs — não sobrescreve `dotnetSdks`).

- [ ] **Step 1: Copiar hardware-configuration.nix**

```bash
cp nixos/hosts/virtual-machine/hardware-configuration.nix modules/hosts/nixos/virtual-machine/hardware-configuration.nix
```

- [ ] **Step 2: `modules/hosts/nixos/virtual-machine/default.nix`**

```nix
{ config, inputs, ... }:
{
  flake.nixosConfigurations.virtual-machine = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = { inherit inputs; };
    modules = [
      ./hardware-configuration.nix
      { host.name = "virtual-machine"; }
      { nixpkgs.config.allowUnfree = true; }
    ]
    ++ (with config.flake.modules.nixos; [
      base
      nixSettings
      nixLd
      networking
      locale
      user
      inotify
      grub
      hardwareCommon
      audio
      gnome
      mediaCodecs
      cliPkgs
      guiPkgs
      flatpak
      distrobox
      docker
      vmGuest
    ])
    ++ [
      {
        home-manager.users.${config.host.user.name}.imports = with config.flake.modules.homeManager; [
          base
          gh
          git
          direnv
          nodejs
          python
          dotnet
          cliTools
          zsh
          starship
          claudeCode
          zedEditor
          kitty
          flameshot
          copyq
        ];
      }
    ];
  };
}
```

**Nota:** `boot.loader.systemd-boot` não está na lista (o host legado usa `grub`, não
`systemd-boot`, conforme `nixos/hosts/virtual-machine/configuration.nix` lido durante
a pesquisa) — confirmado, `systemdBoot` fica de fora deste host.

- [ ] **Step 3: Verificar**

Run: `nix flake check`
Expected: passa sem erro.

Run: `nix build .#nixosConfigurations.virtual-machine.config.system.build.toplevel --dry-run`
Expected: avalia e resolve os derivations sem erro (não builda de fato, só valida).

- [ ] **Step 4: Commit**

```bash
git add modules/hosts/nixos/virtual-machine
git commit -m "feat(hosts): migrate virtual-machine NixOS host"
```

---

### Task 14: Host NixOS — `precision-7540`

**Files:**
- Create: `modules/hosts/nixos/precision-7540/default.nix`
- Copy: `modules/hosts/nixos/precision-7540/hardware-configuration.nix`
  (de `nixos/hosts/precision-7540/hardware-configuration.nix`, sem alteração)

**Interfaces:**
- Consumes: mesmos módulos do Task 13, mais `nixos-hardware` (import direto, como
  hoje).
- Produces: `flake.nixosConfigurations.precision-7540`.

Matriz: completo em kitty/zed-editor/claude-code, **`dotnetSdks` sobrescrito pra
`[]`** (só `dotnet-ef`, igual ao `dotnet/config` de hoje), **sem** flameshot/copyq,
kernelParams e monitores inline (dado único da máquina, não vira módulo — regra 6 da
spec).

- [ ] **Step 1: Copiar hardware-configuration.nix**

```bash
cp nixos/hosts/precision-7540/hardware-configuration.nix modules/hosts/nixos/precision-7540/hardware-configuration.nix
```

- [ ] **Step 2: `modules/hosts/nixos/precision-7540/default.nix`**

```nix
# Dell Precision 7540 — Intel Core i9-9980HK (Coffee Lake) + NVIDIA Quadro
# RTX 3000 Mobile / Max-Q (Turing) hybrid graphics, confirmado via `lspci`.
# Sem perfil "precision-7540" exato em nixos-hardware; geração mais próxima é
# dell/precision/5530 (mesma família CPU/GPU) — composto das mesmas peças
# genéricas que ele usa, em vez de copiá-lo inteiro.
{ config, inputs, ... }:
{
  flake.nixosConfigurations.precision-7540 = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = { inherit inputs; };
    modules = [
      "${inputs.nixos-hardware}/common/cpu/intel/coffee-lake"
      "${inputs.nixos-hardware}/common/gpu/nvidia/turing"
      "${inputs.nixos-hardware}/common/gpu/nvidia/prime.nix"
      "${inputs.nixos-hardware}/common/pc/laptop"
      "${inputs.nixos-hardware}/common/pc/ssd"

      ./hardware-configuration.nix
      { host.name = "precision-7540"; }
      { nixpkgs.config.allowUnfree = true; }

      # Mesmos kernel params do dell/precision/5530 (mesma geração de chassi, não
      # vendorizado via esse perfil porque ele fixa a geração Pascal da GPU em
      # vez de Turing — ver comentário acima) — dado único desta máquina.
      {
        boot.kernelParams = [
          # corrige lspci travando com nouveau
          # fonte https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1803179/comments/149
          "acpi_rev_override=1"
          "acpi_osi=Linux"
          "nouveau.modeset=0"
          "pcie_aspm=force"
          "drm.vblankoffdelay=1"
          "nouveau.runpm=0"
          "mem_sleep_default=deep"
          # corrige flicker
          # fonte https://wiki.archlinux.org/index.php/Intel_graphics#Screen_flickering
          "i915.enable_psr=0"
          "nvidia_drm.modeset=1"
        ];
      }
    ]
    ++ (with config.flake.modules.nixos; [
      base
      nixSettings
      nixLd
      networking
      locale
      user
      inotify
      systemdBoot
      hardwareCommon
      intel
      nvidia
      audio
      gnome
      mediaCodecs
      cliPkgs
      guiPkgs
      flatpak
      distrobox
      docker
    ])
    ++ [
      {
        home-manager.users.${config.host.user.name} = {
          imports = with config.flake.modules.homeManager; [
            base
            gh
            git
            direnv
            nodejs
            python
            dotnet
            cliTools
            zsh
            starship
            claudeCode
            zedEditor
            kitty
          ];
          dotnetSdks = lib.mkForce [ ]; # dotnet-ef só, sem os SDKs completos aqui
        };
      }
    ];
  };
}
```

**Nota:** falta `lib` nos argumentos da função do `home-manager.users.${...}` acima
(usa `lib.mkForce`) — o bloco `{ home-manager.users... }` precisa virar
`{ lib, config, ... }: { home-manager.users.${config.host.user.name} = { ... }; }`
antes de rodar. Corrigir no Step 3.

- [ ] **Step 3: Corrigir o bloco final pra receber `lib`**

Trocar o último elemento da lista `++ [ ... ]` de `{ home-manager.users... }` pra:

```nix
    ++ [
      (
        { lib, config, ... }:
        {
          home-manager.users.${config.host.user.name} = {
            imports = with config.flake.modules.homeManager; [
              base
              gh
              git
              direnv
              nodejs
              python
              dotnet
              cliTools
              zsh
              starship
              claudeCode
              zedEditor
              kitty
            ];
            dotnetSdks = lib.mkForce [ ];
          };
        }
      )
    ];
```

- [ ] **Step 4: Verificar**

Run: `nix flake check`
Expected: passa sem erro.

Run: `nix build .#nixosConfigurations.precision-7540.config.system.build.toplevel --dry-run`
Expected: avalia sem erro.

- [ ] **Step 5: Commit**

```bash
git add modules/hosts/nixos/precision-7540
git commit -m "feat(hosts): migrate precision-7540 NixOS host"
```

---

### Task 15: Host Home Manager standalone — `macbook`

**Files:**
- Create: `modules/hosts/home-manager/macbook.nix`

**Interfaces:**
- Consumes: `flake.modules.homeManager.*` das tasks 2, 5-12.
- Produces: `flake.homeConfigurations."joaop@macbook"`.

Matriz: completo em gh/git/direnv/nodejs/python/cli-tools/zsh/starship;
`dotnetSdks = lib.mkForce [ ]`; `programs.{claude-code,zed-editor,kitty}.package = lib.mkForce null`.

- [ ] **Step 1: `modules/hosts/home-manager/macbook.nix`**

```nix
{ config, inputs, lib, ... }:
{
  flake.homeConfigurations."joaop@macbook" = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = import inputs.nixpkgs { system = "aarch64-darwin"; config.allowUnfree = true; };
    extraSpecialArgs = { inherit inputs; };
    modules = (with config.flake.modules.homeManager; [
      base
      gh
      git
      direnv
      nodejs
      python
      dotnet
      cliTools
      zsh
      starship
      claudeCode
      zedEditor
      kitty
    ]) ++ [
      {
        host.name = "macbook";
        dotnetSdks = lib.mkForce [ ];
        programs.claude-code.package = lib.mkForce null;
        programs.zed-editor.package = lib.mkForce null;
        programs.kitty.package = lib.mkForce null;
      }
    ];
  };
}
```

- [ ] **Step 2: Verificar**

Run: `nix flake check`
Expected: passa sem erro.

Run: `nix build '.#homeConfigurations."joaop@macbook".activationPackage' --dry-run`
Expected: avalia sem erro.

- [ ] **Step 3: Commit**

```bash
git add modules/hosts/home-manager/macbook.nix
git commit -m "feat(hosts): migrate macbook standalone home-manager profile"
```

---

### Task 16: Host Home Manager standalone — `notebook` (perfil real — por último)

**Pré-requisito:** Tasks 1-15 completas, `nix flake check` limpo, os dois hosts
NixOS e o `macbook` validados via `nix build --dry-run`. Só então mexer neste.

**Files:**
- Create: `modules/hosts/home-manager/notebook.nix`

**Interfaces:**
- Consumes: `flake.modules.homeManager.*` das tasks 2, 5-12.
- Produces: `flake.homeConfigurations."joaop@notebook"`.

Matriz: idêntica ao `macbook`, trocando só `system`/`host.name`.

- [ ] **Step 1: `modules/hosts/home-manager/notebook.nix`**

```nix
{ config, inputs, lib, ... }:
{
  flake.homeConfigurations."joaop@notebook" = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = import inputs.nixpkgs { system = "x86_64-linux"; config.allowUnfree = true; };
    extraSpecialArgs = { inherit inputs; };
    modules = (with config.flake.modules.homeManager; [
      base
      gh
      git
      direnv
      nodejs
      python
      dotnet
      cliTools
      zsh
      starship
      claudeCode
      zedEditor
      kitty
    ]) ++ [
      {
        host.name = "notebook";
        dotnetSdks = lib.mkForce [ ];
        programs.claude-code.package = lib.mkForce null;
        programs.zed-editor.package = lib.mkForce null;
        programs.kitty.package = lib.mkForce null;
      }
    ];
  };
}
```

- [ ] **Step 2: Verificar (só avaliação, nunca aplicar)**

Run: `nix flake check`
Expected: passa sem erro.

Run: `nix build '.#homeConfigurations."joaop@notebook".activationPackage' --dry-run`
Expected: avalia sem erro. **Não rodar `home-manager switch` — isso é decisão do
usuário, fora deste plano.**

- [ ] **Step 3: Commit**

```bash
git add modules/hosts/home-manager/notebook.nix
git commit -m "feat(hosts): migrate notebook standalone home-manager profile"
```

- [ ] **Step 4: Avisar o usuário**

Reportar que `modules/hosts/home-manager/notebook.nix` está pronto e validado via
build a seco, e que rodar `home-manager switch --flake .#joaop@notebook` na máquina
real é decisão do usuário — não executar por conta própria.

---

### Task 17: Cleanup — remover árvore antiga, atualizar README

**Pré-requisito:** Task 16 completa e o usuário confirmou que quer prosseguir com a
remoção da árvore antiga (isso é uma exclusão de arquivo — confirmar antes de rodar
`git rm`).

**Files:**
- Delete: `home-manager/`, `nixos/`, `lib/`
- Modify: `README.md`

**Interfaces:** nenhuma (fim da migração).

- [ ] **Step 1: Remover as árvores antigas**

```bash
git rm -r home-manager nixos lib
```

- [ ] **Step 2: Verificar que nada quebrou**

Run: `nix flake check`
Expected: passa sem erro (nada em `modules/` referenciava as pastas antigas por
path — só por nome de atributo `flake.modules.*`).

- [ ] **Step 3: Atualizar `README.md`**

Reescrever a seção "Estrutura" do `README.md` pra refletir `modules/` (não mais
`hosts/`+`modules/` do README atual, que já estava desatualizado antes deste plano)
— descrever `modules/{nix,programs,services,system,hosts}/`, a regra de
arquivo-solto-vs-pasta (seção 6 da spec), e o mecanismo de override
`programs.<app>.package = lib.mkForce null` pro eixo pacote-vs-nativo.

- [ ] **Step 4: Commit**

```bash
git add -A
git commit -m "refactor: remove legacy home-manager/nixos/lib trees, update README"
```

---

## Self-Review

**Cobertura da spec:** seções 1-6 da spec mapeadas — fundação flake-parts (T1),
`host.*` (T2), pastas por feature (estrutura geral do plano), toggle seletivo por
host (T13-16), pacote-vs-nativo via override de opção real (T8-16), regra
arquivo-vs-pasta (aplicada em cada task de módulo).

**Pontos sinalizados como incompletos, propositalmente** (conteúdo não lido durante
a pesquisa que fundamentou este plano — marcado explicitamente em vez de inventado):
`nixos/modules/boot/grub.nix` (Task 3, Step 7), `nixos/modules/desktop/plasma.nix`
(Task 3, Step 10), `home-manager/modules/zsh/config/{aliases,init-content,oh-my-zsh}.nix`
(Task 6, Step 2). Quem executar essas tasks deve ler o arquivo original primeiro.

**Consistência de nomes:** conferido `flake.modules.nixos.*`/`flake.modules.homeManager.*`
usados nas tasks de host (13-16) contra os nomes produzidos nas tasks 1-12 — batem.
