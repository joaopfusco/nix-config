---
paths:
  - "modules/home/**"
  - "modules/nixos/**"
---

# Módulos (`modules/home/`, `modules/nixos/`)

## `package = null` vs `pkgs.emptyDirectory`

Ao escrever um `modules/home/<app>/config/default.nix` config-only (sem instalar o
binário), o valor de `programs.<app>.package` depende do módulo real do Home Manager —
não assumir por hábito:

1. Achar o módulo (input `home-manager` já está fetched — ver `flake.lock`) e conferir
   como `package` é declarado: `grep -n 'mkPackageOption pkgs "<app>"' <módulo>`.
2. Se `nullable = true` → usar `package = lib.mkDefault null;`.
3. Se não aceita `null` → usar `package = lib.mkDefault pkgs.emptyDirectory;`.

Isso importa porque alguns módulos gatam funcionalidades reais em `cfg.package != null`
(ex.: `claude-code` recusa configurar MCP servers/plugins sem pacote real). Passar
`emptyDirectory` no lugar de `null` satisfaz esse assert com um pacote vazio, sem o efeito
que o autor do módulo pretendia — conferir usos de `cfg.package == null`/`!= null` no
source do módulo, não só a declaração da option.

**Estado atual:** `claude-code` já usa `null` corretamente (e sua própria assertion
depende disso). `git`, `kitty`, `zed-editor` usam `emptyDirectory` por terem copiado o
padrão antigo do `zed.nix`, não por checar cada option — não é bug ativo hoje porque as
sub-options gateadas nesses módulos (`git.maintenance.enable`,
`zed.extraPackages`/`defaultEditor`) não são usadas neste repo. Se a config de
git/kitty/zed crescer a ponto de tocar essas options, revisitar. `direnv`, `gh`, `zsh`
não aceitam `null` — `emptyDirectory` é a única opção aí, não um atalho.

## Decisões nativo vs. nix por app

Pra cada app com split `config/` + `default.nix`, se o **binário** vem do nix ou fica
nativo (apt/brew/instalador oficial, só a config via Home Manager) foi decidido caso a
caso, não "nix é sempre melhor":

**Nativo** (config ainda via Home Manager):
- `git`, `zsh` — fundamentais, mudam devagar, o pacote da distro já é bem cuidado e mais
  rápido que o ciclo do nixpkgs; sem ganho real numa versão mais nova via nix.
- `kitty` — preferência explícita já testada (nix como opção, escolhido apt).
- `zed` — má combinação como pacote nix fora de NixOS (problemas de dynamic-linking/FHS —
  mesmo motivo de existir `zed-editor-fhs` no nixpkgs).
- `dotnet` (SDK completo) — mesma classe de problema do zed (interop nativo, runtime
  pesado).
- `claude-code` (o binário CLI) — evolui rápido demais (releases quase diárias) pro ritmo
  de empacotamento do nixpkgs; instalador oficial/npm se mantém mais atualizado.

**Nix:**
- `direnv`, `gh` — baixo risco, sem vantagem de curadoria do apt/Homebrew pra esses;
  `gh` especificamente saiu do Homebrew pra consolidar fontes de pacote.
- `azure-cli` — nix **só em hosts NixOS** (não há alternativa lá). Em perfis standalone
  fica no apt de propósito: é o repositório apt oficial da Microsoft, atualiza rápido
  acompanhando a API do Azure, e o pacote do nixpkgs (deps/extensions Python pesadas) é um
  ponto fraco conhecido. Não existe módulo `programs.azure-cli` do Home Manager — é uma
  entrada simples em `home.packages` (`modules/home/azure-cli/default.nix`).

## `zed` — symlink out-of-store

A config do zed usa `config.lib.file.mkOutOfStoreSymlink`, não
`programs.zed-editor.userSettings`/`userKeymaps`: `xdg.configFile."zed/settings.json"` e
`keymap.json` apontam direto pros arquivos JSON simples em `modules/home/zed/config/`
(edição live, sem `home-manager switch`, versionado por construção). Por isso,
`programs.zed-editor.extensions` **não é usado** — essa option escreve em
`settings.json` via `home.activation` mesmo com `userSettings` vazio, o que colide com o
symlink out-of-store. Extensões são declaradas do jeito nativo do zed, via
`auto_install_extensions` direto no `settings.json` real.
