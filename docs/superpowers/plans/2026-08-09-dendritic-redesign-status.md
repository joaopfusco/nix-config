# Status da migração flake-parts/dendritic — 2026-08-09

Plano original: `docs/superpowers/plans/2026-08-08-modules-dendritic-redesign.md` (17 tasks).
Spec: `docs/superpowers/specs/2026-08-08-modules-dendritic-redesign-design.md`.

## Estado: Tasks 1–12 completas e commitadas. Task 13 travada.

### Commits na branch `refactor/architecture` (mais recente primeiro)

```
343d08e feat(hosts): migrate virtual-machine NixOS host        (Task 13 — quebrado, ver abaixo)
0ce8c32 fix(flake): expose default overlay, set system.stateVersion for nixos hosts, fix dotnet module option/config syntax
0c01e5c feat(home-manager): migrate distrobox-export module (unattached, matches current orphan state)   (Task 12)
dc23ed2 feat(home-manager): migrate claude-code module          (Task 11)
96f17d4 feat(home-manager): migrate zed-editor module            (Task 10)
b27ce4f feat(home-manager): migrate kitty, copyq, flameshot modules (Task 9)
d494ca1 feat(home-manager): migrate dotnet module with dotnetSdks override option (Task 8)
14a5ea8 feat(home-manager): migrate starship module               (Task 7)
6c973f3 feat(home-manager): migrate zsh module                    (Task 6)
3a902d2 feat(home-manager): migrate simple always-on program modules (Task 5)
1e61831 feat(nixos): migrate system package bundles and services  (Task 4)
bcffb8b feat(nixos): migrate system modules (boot, desktop, hardware, locale, networking, user, nix) (Task 3)
00f784b feat(flake): add host.* namespace and home-manager wiring (Task 2)
b1dce68 feat(flake): adopt flake-parts + import-tree foundation   (Task 1)
```

Tasks 1–12 passam em `nix flake check` limpo. Tasks 5–12 cobrem todos os módulos de
programa do Home Manager (`modules/programs/**`); Tasks 3–4 cobrem todos os módulos de
sistema NixOS (`modules/system/**`, `modules/services/**`).

### Task 13 (virtual-machine) — commit `343d08e` está quebrado

O `nix flake check` **não passa** no estado commitado. Working tree tem edições não
commitadas (do usuário, em andamento) tentando resolver o problema abaixo — ver
"Estado dos arquivos agora".

## Bugs encontrados no plano original (não previstos, corrigidos durante a execução)

1. **`import-tree` ignora paths com `/_`, mas nada no plano usava isso.** Qualquer
   `.nix` sob `modules/` que não deva virar um módulo flake-parts próprio (porque é
   conteúdo cru importado via path relativo por outro arquivo) precisa do prefixo `_`
   no nome — senão o `import-tree` auto-importa ele TAMBÉM como módulo flake-parts de
   primeiro nível, e ele quebra (não tem os argumentos especiais que espera, tipo
   `modulesPath`). Dois casos reais:
   - `modules/programs/zsh/{aliases,init-content,oh-my-zsh}.nix` → renomeados pra
     `_aliases.nix`, `_init-content.nix`, `_oh-my-zsh.nix` (Task 6, já commitado).
   - `hardware-configuration.nix` de cada host NixOS (Task 13+) → precisa do mesmo
     tratamento (`_hardware.nix` ou similar). Sem isso, o `modulesPath` usado pelo
     `nixos-generate-config` (`imports = [ (modulesPath + "/profiles/qemu-guest.nix") ]`)
     causa `infinite recursion encountered` — o import-tree tenta avaliar esse arquivo
     como módulo flake-parts solto, que não tem `modulesPath` nos specialArgs.

2. **`flake.nixosConfigurations` já é opção nativa do flake-parts** (built-in, sempre
   carregado, `modules/nixosConfigurations.nix` do próprio flake-parts). O Task 1 do
   plano original declarava essa opção de novo em `modules/nix/flake-parts.nix`,
   conflitando. Corrigido: removida a declaração redundante, mantido só
   `flake.homeConfigurations` (esse sim não é nativo).

3. **`modules/programs/dotnet.nix` (Task 8) misturava `options.dotnetSdks = ...;` com
   `home.packages`/`home.sessionPath`/`home.sessionVariables` soltos no mesmo nível.**
   Isso é sintaxe de módulo inválida — quando um módulo declara `options` (ou `config`)
   explicitamente, tudo mais precisa estar dentro de `config = { ... };`, não solto ao
   lado. Corrigido: os `home.*` agora estão dentro de um `config = { ... };` explícito.

4. **Faltava `system.stateVersion` pros hosts NixOS.** A Task 2 do plano só setava
   `home.stateVersion` (via `config.host.state.version`) no módulo `homeManager.base`;
   o `nixos.base` não setava `system.stateVersion`. Corrigido em
   `modules/nix/host-options.nix`: `flake.modules.nixos.base` agora também seta
   `system.stateVersion = config.host.state.version;`.

5. **Faltava expor o overlay stable→`pkgs.unstable`.** Esse overlay só existia dentro
   do `perSystem` de `modules/nix/nixpkgs.nix` (usado pra `legacyPackages`/`nix shell
   pkgs#...`), mas os hosts NixOS constroem o próprio `pkgs` via `nixosSystem` e
   precisam do MESMO overlay pra `pkgs.unstable.google-chrome`/`pkgs.unstable.firefox`
   (usados em `modules/system/pkgs/gui.nix`) funcionarem. Corrigido: `flake.overlays.default`
   exposto em `modules/nix/nixpkgs.nix`.

## O problema ainda em aberto (bloqueando Task 13 em diante)

Nos arquivos de host (`modules/hosts/nixos/<host>/default.nix`,
`modules/hosts/home-manager/<perfil>.nix`), a assinatura da função é
`{ config, inputs, ... }:`. Esse `config` é o **config de nível flake-parts** — porque
o próprio arquivo é auto-importado pelo `import-tree` como módulo flake-parts (regra 1
acima). Duas coisas precisam ser lidas nesse arquivo, de dois "lugares" diferentes:

- `config.flake.modules.nixos.*` / `config.flake.modules.homeManager.*` / `config.flake.overlays.default`
  — **existem só no config de nível flake-parts** (o `config` do próprio arquivo).
- `config.host.user.name` (pra indexar `home-manager.users.${...}`) — **só existe
  dentro do config de um sistema NixOS/HM já avaliado** (populado pelo módulo `base`),
  não no config de nível flake-parts. Se usado direto no `config` do arquivo, dá
  `error: attribute 'host' missing`. Se a gente tenta resolver isso envolvendo o bloco
  numa função `{ config, ... }: { ... }` aninhada (pra pegar o config "de dentro" do
  sistema), aí quem quebra é o `config.flake.modules.homeManager` — porque agora
  `config` foi sombreado pelo config do sistema NixOS, que não tem `.flake`
  (`error: attribute 'flake' missing`).

As duas coisas não cabem na mesma função sem uma sombrear a outra.

**Como o repo de referência (`MatthiasBenaets/nix-config` — flake-parts + dendritic,
NixOS + nix-darwin + Home Manager standalone, citado na spec) resolve isso:** cada
arquivo de host define um **valor Nix puro local** (`let host = { name = ...; user.name
= ...; state.version = ...; system = ...; };`), SEM depender do sistema de módulos pra
esse indexamento. `${host.user.name}` usa esse valor puro (sempre disponível, sem
round-trip pelo module system). O record inteiro é então injetado no config real via
`inherit host;` (ou seja, vira o valor literal da opção `host` daquele sistema
NixOS/HM), pra que outros módulos que leem `config.host.*` de dentro do sistema
continuem funcionando normalmente. Confirmado nos 3 hosts NixOS do repo de referência
(`vm`, `beelink`, `work`) — todos duplicam `user.name = "matthias";` no `let host`
local de cada arquivo, não centralizam num único lugar.

Isso foi proposto e a última tentativa de aplicar (commit não feito, ver abaixo) foi
rejeitada em revisão — não ficou claro qual parte especificamente não serve. **Decisão
de como resolver esse indexamento precisa ser tomada antes de prosseguir**, porque as
Tasks 14, 15 e 16 (mais 2 hosts NixOS e 2 perfis Home Manager standalone) vão bater no
mesmo problema.

## Estado dos arquivos agora (não commitado, working tree)

- `modules/hosts/nixos/virtual-machine/default.nix` — modificado, com a tentativa de
  usar `config.host.user.name` dentro de uma função aninhada (quebra com `attribute
  'flake' missing`, ver acima).
- `modules/nix/home-manager.nix` — modificado: o bloco `flake.modules.nixos.base`
  (import do `home-manager.nixosModules.home-manager` + `useGlobalPkgs`/
  `useUserPackages`/`extraSpecialArgs`) foi removido daqui.
- `modules/nix/nixos.nix` — **novo arquivo, não rastreado pelo git ainda.** Parece ser
  onde esse bloco foi movido pra, mas está incompleto/experimental: tem uma chave
  `modules = [ { nixpkgs.config.allowUnfree = true; nixpkgs.overlays = [
  config.flake.overlays.default ]; } ];` dentro de `flake.modules.nixos.base` que não é
  uma opção NixOS válida (`modules` não é opção de sistema, é parâmetro do
  `nixosSystem`) — e o `config.flake.overlays.default` ali de dentro provavelmente cai
  no mesmo problema de shadowing descrito acima, já que esse `config` é o do próprio
  módulo NixOS `base`, não o de nível flake-parts.
- `modules/hosts/nixos/virtual-machine/_hardware.nix` — renomeado de
  `hardware-configuration.nix` (regra 1 acima), já commitado, correto.

Nenhum desses três arquivos modificados/novos está commitado. `nix flake check`
atualmente falha nesse estado.

## Tasks restantes (do plano original)

- **Task 13** — Host NixOS `virtual-machine`. Commitado mas quebrado (ver acima);
  precisa da correção do indexamento de username pra fechar.
- **Task 14** — Host NixOS `precision-7540`. Vai precisar do mesmo padrão de host que
  sair da Task 13, mais `nixos-hardware` (imports diretos já confirmados no
  `configuration.nix` original: `coffee-lake`, `nvidia/turing`, `nvidia/prime.nix`,
  `pc/laptop`, `pc/ssd`) e `dotnetSdks = lib.mkForce [ ]` (só `dotnet-ef`, sem os FHS
  envs completos). `_hardware-configuration.nix` desse host hoje é um placeholder
  (máquina ainda roda Ubuntu) — copiar verbatim, sem inventar UUIDs reais.
- **Task 15** — Host Home Manager standalone `macbook`. `dotnetSdks = lib.mkForce [ ]`
  + `programs.{claude-code,zed-editor,kitty}.package = lib.mkForce null` (config-only).
- **Task 16** — Host Home Manager standalone `notebook` — **o perfil real, aplicado na
  máquina principal.** Só mexer depois de 13–15 validados via `nix build --dry-run`.
  Nunca rodar `home-manager switch` de verdade nesse plano — é decisão do usuário.
- **Task 17** — Cleanup: remover `home-manager/`, `nixos/`, `lib/` antigos + atualizar
  `README.md`. Só depois de confirmação explícita do usuário (é `git rm`).

## Próximo passo

Fechar, com o usuário, qual é o padrão definitivo pro indexamento
`home-manager.users.${username}` nos arquivos de host — antes de tocar em mais nenhuma
task, pra não repetir o mesmo ciclo de tentativa-e-erro em 13, 14, 15 e 16.
