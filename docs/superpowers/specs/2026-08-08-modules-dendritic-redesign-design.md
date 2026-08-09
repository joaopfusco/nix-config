# Redesenho de arquitetura do nix-config: flake-parts + dendritic pattern

## Contexto

O `nix-config` hoje mistura três formatos de módulo do Home Manager (arquivo solto
pacote+config; pasta com `config/` + `default.nix` pra separar pacote de config; e,
dentro de `config/`, ora settings gerado via opções do Nix, ora link simbólico pro
dotfile) sem uma regra clara de quando usar cada um. A escolha de qual variante usar
por máquina é feita hoje **importando o path certo** em cada `home.nix`
(`../../modules/dotnet` vs `../../modules/dotnet/config`), o que é frágil e opaco.

Além disso NixOS (`nixos/`) e Home Manager standalone (`home-manager/`) são pastas
top-level separadas, cada uma com sua própria árvore de módulos — mesmo quando a
mesma feature (zsh, git) existe nas duas.

Este documento redesenha a estrutura em cima do **dendritic pattern** com
**flake-parts**, seguindo o mais de perto possível práticas documentadas de
repositórios reais, não invenção própria.

## Referências usadas

- [mightyiam/dendritic](https://github.com/mightyiam/dendritic) — repo canônico do padrão.
- [MatthiasBenaets/nix-config](https://github.com/MatthiasBenaets/nix-config) — NixOS + nix-darwin + Home Manager
  standalone desacoplados, flake-parts + dendritic. Caso mais próximo do nosso encontrado.
- [Doc-Steve/dendritic-design-with-flake-parts](https://github.com/Doc-Steve/dendritic-design-with-flake-parts)
  (via resumo em [mattstruble/skills nix-dendritic](https://github.com/mattstruble/skills/blob/main/nix-dendritic/SKILL.md)) —
  guia de convenções de pastas e nomenclatura.
- [vic/import-tree](https://github.com/vic/import-tree) — auto-import de todo `.nix`
  sob um diretório como módulo do flake-parts.

## Decisões de arquitetura

### 1. flake-parts + import-tree, sem `lib/` de scan manual

`flake.nix` fica reduzido a inputs + `flake-parts.lib.mkFlake` +
`imports = [ (inputs.import-tree ./modules) ]`. `lib/packages.nix`, `lib/profiles.nix`
e `lib/home-manager.nix` deixam de existir como scripts que fazem `builtins.readDir`
pra descobrir hosts/perfis — cada host/perfil se registra sozinho como saída do
flake (`flake.nixosConfigurations.<nome>` / `flake.homeConfigurations.<nome>`) no seu
próprio arquivo, e o `import-tree` garante que ele é avaliado sem entrar em nenhuma
lista central.

### 2. Pastas organizadas por o que a feature faz, não por classe de config

Nada de `home-manager/` e `nixos/` como pastas de topo — isso reproduz exatamente o
problema de uma feature ficar partida em dois lugares. Seguindo a convenção
documentada (Doc-Steve/mattstruble):

- `modules/nix/` — boilerplate do framework (overlays, wiring do home-manager,
  declaração das opções compartilhadas `host.*`).
- `modules/programs/` — apps de usuário (zsh, git, zed-editor, claude-code...).
- `modules/services/` — serviços de sistema (docker, flatpak, distrobox).
- `modules/system/` — config de sistema (locale, rede, boot, hardware, desktop).
- `modules/hosts/` — composição por máquina (fina, só importa o que aquele host usa).

### 3. Namespace de dados compartilhados: `host.*`

Copiado quase literal do `MatthiasBenaets/nix-config` (`modules/hosts/options.nix`):
`host.name`, `host.user.name`, `host.system`, `host.state.version`,
`host.isNixOS` / `host.isDarwin` / `host.isHomeManager`. Substitui o
`extraSpecialArgs`/`osConfig == null` manual que existe hoje em `lib/home-manager.nix`.

### 4. Toggle de feature = presença no `imports` do host, não opção customizada

Confirmado por três fontes independentes (código real do MatthiasBenaets + guia
Doc-Steve/mattstruble): **não existe** um `options.mine.<app>.enable` inventado. Um
host liga uma feature simplesmente incluindo o nome dela:

```nix
modules = with config.flake.modules.homeManager; [ zsh git kitty claude-code ];
```

Renomear/mover o arquivo `.nix` nunca quebra essa referência, porque ela aponta pro
nome no attrset (`flake.modules.<classe>.<nome>`), não pro caminho do arquivo.

### 5. Pacote-vs-só-config: um único aspecto por app; o host sobrescreve a opção real

**Avaliado e descartado: [feel-co/hjem](https://github.com/feel-co/hjem).** Ferramenta
real e ativamente mantida, teria separado pacote de config de forma limpa. Mas: sem
release versionado (só `main` rolante, sem contrato de API estável), projeto com menos
de 2 anos, e em toda a pesquisa sobre o dendritic pattern feita pra este documento
(MatthiasBenaets/nix-config, guia Doc-Steve/mattstruble, mightyiam/dendritic, thread do
NixOS Discourse sobre estrutura de dotfiles dendritic) **ninguém usa hjem combinado com
esse padrão**. Não é "como as pessoas realmente fazem" — é aposta em ferramenta
nichada. Descartado.

**Também descartado: dois módulos nomeados por app** (`kitty` vs `kitty-dotfiles`),
escolhidos por import no host — é o mesmo problema do ponto 1 do documento (escolher
qual variante importar), só que trocando path por nome. Continua sendo o host
decidindo "qual arquivo pego" em vez de configurar uma opção.

**Decisão final:** cada app tem **um único aspecto**, sempre o mesmo, sempre
importado. A config (tipada ou arquivo cru — eixo independente, escolha por app) é
aplicada incondicionalmente dentro do módulo. "Pacote via Nix ou nativo" não é uma
escolha de import — é o host **sobrescrevendo a opção real** que o próprio módulo do
app já expõe (`programs.<app>.package`), usando o mecanismo do próprio sistema de
módulos do Nix pra isso (`lib.mkForce`):

```nix
# modules/programs/kitty.nix — um aspecto só, sempre igual
{
  flake.modules.homeManager.kitty = { pkgs, ... }: {
    programs.kitty = {
      enable = true;
      # package não é setado aqui — usa o default do próprio módulo (pkgs.kitty)
      settings = { shell_integration = "enabled"; window_padding_width = 4; };
    };
  };
}
```

```nix
# modules/hosts/home-manager/notebook.nix — host sobrescreve a opção, não escolhe import
{
  flake.homeConfigurations."joaop@notebook" = inputs.home-manager.lib.homeManagerConfiguration {
    modules = (builtins.attrValues config.flake.modules.homeManager) ++ [
      { programs.kitty.package = lib.mkForce null; }  # kitty vem do apt aqui
    ];
  };
}
```

`programs.kitty.package` já é `lib.mkPackageOption pkgs "kitty" { nullable = true; }`
no próprio Home Manager (confirmado lendo o código-fonte do módulo) — não é gambiarra,
é a opção de primeira classe que o módulo já declara pra exatamente esse propósito.
Confirmar caso a caso, na migração, se o módulo do app aceita `null`; se não aceitar,
`lib.mkForce pkgs.emptyDirectory` é o fallback. Pra apps de config crua (zed-editor,
claude-code) o mesmo padrão vale: `programs.<app>.enable = true;` fica sempre no
módulo (traz o pacote por padrão), o `xdg.configFile`/`home.file` com
`mkOutOfStoreSymlink` aplica incondicionalmente, e o host que quiser o binário nativo
sobrescreve `programs.<app>.package = lib.mkForce null;` do mesmo jeito.

### 6. Forma de módulo: arquivo solto por padrão; pasta por dois motivos, nunca por terceiro

Regra única, aplicada sem exceção:

- **Arquivo solto** (`modules/programs/git.nix`) é o padrão — feature cujo conteúdo é
  só Nix (sem asset cru, sem irmão relacionado).
- **Pasta com `default.nix`** só acontece por um destes dois motivos, nunca por "achei
  que ficava mais organizado":
  1. A feature tem **asset cru companheiro** que precisa existir como arquivo próprio
     (dotfile symlinkado, script, `.toml`/`.json` de verdade) — ex.
     `modules/programs/zsh/{default.nix,p10k.zsh}` (mesmo padrão do
     `MatthiasBenaets/nix-config`), `modules/programs/starship/{default.nix,starship.toml}`.
  2. Um grupo de arquivos `.nix` **irmãos** trata do mesmo assunto e faz sentido like
     ler junto — ex. `modules/system/hardware/{common,intel,nvidia,audio}.nix` (mesmo
     agrupamento que já existe hoje em `nixos/modules/hardware/`, e que o
     `MatthiasBenaets/nix-config` também usa: `modules/hardware/`, `modules/gui/`,
     `modules/theme/`). Nesse caso **não** existe um único `default.nix` — cada
     arquivo da pasta é seu próprio módulo nomeado (`flake.modules.nixos.audio`,
     `flake.modules.nixos.nvidia`, etc.), a pasta é só agrupamento de arquivos pro
     humano, o `import-tree` importa cada um individualmente.
- Nunca cria pasta pra um único arquivo `.nix` sem asset cru — isso é sempre arquivo
  solto (`dotnet.nix`, `kitty.nix`, `copyq.nix`, `flameshot.nix` — nenhum tem dotfile
  cru: o ini do flameshot é *gerado* via `pkgs.formats.ini`, não symlinkado).

## Estrutura de pastas completa

```
nix-config/
├── flake.nix
├── flake.lock
└── modules/
    ├── nix/
    │   ├── flake-parts.nix        # options.flake.homeConfigurations/nixosConfigurations
    │   ├── nixpkgs.nix            # ex-lib/packages.nix: perSystem pkgs, overlay unstable
    │   ├── home-manager.nix       # ex-lib/home-manager.nix: wiring do input home-manager
    │   └── host-options.nix       # host.* (ex MatthiasBenaets/nix-config)
    ├── programs/
    │   ├── git.nix
    │   ├── direnv.nix
    │   ├── gh.nix
    │   ├── cli-tools.nix           # ex-cli.nix (home-manager), grab-bag sem config
    │   ├── nodejs.nix
    │   ├── python.nix
    │   ├── dotnet.nix               # sem asset cru → arquivo solto
    │   ├── kitty.nix                # sem asset cru → arquivo solto
    │   ├── copyq.nix                # sem asset cru → arquivo solto
    │   ├── flameshot.nix            # ini gerado via pkgs.formats.ini → arquivo solto
    │   ├── zsh/                     # pasta: 4 .nix irmãos sobre o mesmo assunto
    │   │   ├── default.nix
    │   │   ├── aliases.nix
    │   │   ├── init-content.nix
    │   │   └── oh-my-zsh.nix
    │   ├── starship/                # pasta: asset cru companheiro
    │   │   ├── default.nix
    │   │   └── starship.toml
    │   ├── zed-editor/              # pasta: 2 assets crus companheiros
    │   │   ├── default.nix          # aspecto único: programs.zed-editor.enable + symlinks incondicionais
    │   │   ├── settings.json
    │   │   └── keymap.json
    │   ├── claude-code/             # pasta: árvore inteira de assets crus
    │   │   ├── default.nix
    │   │   ├── CLAUDE.md
    │   │   ├── settings.json
    │   │   ├── hooks/...
    │   │   ├── rules/...
    │   │   ├── references/...
    │   │   └── skills/...
    │   └── distrobox-export/        # pasta: asset cru companheiro (script)
    │       ├── default.nix
    │       └── sync-exports.sh
    ├── services/
    │   ├── docker.nix
    │   ├── flatpak.nix
    │   └── distrobox.nix
    ├── system/
    │   ├── locale.nix
    │   ├── networking.nix
    │   ├── nix-settings.nix        # ex nix/config.nix
    │   ├── nix-ld.nix              # ex nix/ld.nix
    │   ├── user.nix
    │   ├── vm-guest.nix
    │   ├── boot/                   # pasta: agrupamento (mesmo já existente hoje)
    │   │   ├── systemd-boot.nix
    │   │   ├── grub.nix
    │   │   └── inotify.nix
    │   ├── desktop/                # pasta: agrupamento
    │   │   ├── gnome.nix
    │   │   └── plasma.nix
    │   ├── hardware/                # pasta: agrupamento
    │   │   ├── common.nix
    │   │   ├── intel.nix
    │   │   ├── nvidia.nix
    │   │   └── audio.nix
    │   └── pkgs/                   # pasta: agrupamento
    │       ├── cli.nix
    │       ├── gui.nix
    │       └── media-codecs.nix
    └── hosts/
        ├── nixos/
        │   ├── precision-7540/
        │   │   ├── default.nix     # flake.nixosConfigurations.precision-7540; kernelParams e monitores inline (dado único da máquina)
        │   │   └── hardware-configuration.nix
        │   └── virtual-machine/
        │       ├── default.nix
        │       └── hardware-configuration.nix
        └── home-manager/
            ├── notebook.nix        # flake.homeConfigurations."joaop@notebook"
            └── macbook.nix
```

## Tabela de migração

| Hoje | Novo |
|---|---|
| `lib/packages.nix`, `lib/profiles.nix`, `lib/home-manager.nix` | `modules/nix/nixpkgs.nix`, `flake-parts.nix`, `home-manager.nix`, `host-options.nix` |
| `home-manager/modules/zsh/` (+ `cli.nix`, `git.nix`, `direnv.nix`, `gh.nix`, `node.nix`, `python.nix`) | `modules/programs/zsh/`, `cli-tools.nix`, `git.nix`, `direnv.nix`, `gh.nix`, `nodejs.nix`, `python.nix` |
| `home-manager/modules/dotnet/{default.nix,config}` | `modules/programs/dotnet.nix` (arquivo solto — sem asset cru, um único aspecto homeManager) |
| `home-manager/modules/{kitty,copyq,flameshot}/{default.nix,config}` | `modules/programs/{kitty,copyq,flameshot}.nix` (arquivo solto — sem asset cru) |
| `home-manager/modules/{starship,zed-editor,claude-code}/{default.nix,config}` | `modules/programs/<app>/default.nix` (pasta — asset cru companheiro), aspecto único; host sobrescreve `programs.<app>.package = lib.mkForce null;` quando quiser o binário nativo |
| `home-manager/modules/distrobox-export/` | `modules/programs/distrobox-export/` (pasta — asset cru: sync-exports.sh) |
| `nixos/modules/boot/*` | `modules/system/boot/*` |
| `nixos/modules/desktop/*` | `modules/system/desktop/*` |
| `nixos/modules/hardware/*` | `modules/system/hardware/*` |
| `nixos/modules/locale.nix`, `networking.nix`, `user.nix` | `modules/system/locale.nix`, `networking.nix`, `user.nix` |
| `nixos/modules/nix/config.nix`, `nix/ld.nix` | `modules/system/nix-settings.nix`, `modules/system/nix-ld.nix` |
| `nixos/modules/pkgs/*` (menos `flatpak.nix`) | `modules/system/pkgs/*` |
| `nixos/modules/virtualisation/{docker,flatpak}.nix` | `modules/services/{docker,flatpak}.nix` |
| `nixos/modules/virtualisation/{distrobox,vm}.nix` | `modules/services/distrobox.nix`, `modules/system/vm-guest.nix` |
| `nixos/hosts/precision-7540/`, `virtual-machine/` | `modules/hosts/nixos/precision-7540/`, `virtual-machine/` |
| `home-manager/profiles/notebook/`, `macbook/` | `modules/hosts/home-manager/notebook.nix`, `macbook.nix` |

## Fora de escopo

- Migrar `notebook` (perfil real, aplicado na máquina principal) antes de validar o
  resto via `nix flake check` / build a seco — a troca na máquina real é o último
  passo, não o primeiro.
- Adicionar features novas durante a migração — é reorganização, não mudança de
  comportamento.
