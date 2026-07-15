---
paths:
  - "flake.nix"
  - "flake.lock"
---

# Inputs do flake

## Sem o módulo `determinate`

Não adicionar o input `determinate`
(`https://flakehub.com/f/DeterminateSystems/determinate/3`) nem seus
`nixosModules.default`/`homeManagerModules.default`, a menos que seja pedido
explicitamente de novo — decisão já avaliada e descartada, não um esquecimento.

- **Módulo NixOS** (instala Determinate Nix substituindo o Nix stock do NixOS): sem
  ganho que compense a complexidade extra (fork + daemon a mais) — o valor incremental
  (FlakeHub Cache, GC automático via `determinate-nixd`) já é coberto pelo
  `nix.gc.automatic` nativo (`modules/nixos/nix.nix`).
- **Módulo Home Manager** (`nix.package = null`, pra não conflitar com um Determinate Nix
  já instalado em máquina standalone): chegou a ser implementado, mas causava erro de
  eval em hosts NixOS (`home-manager.users.<user>.nix.package` definido `null` e
  não-`null` ao mesmo tempo, já que `useGlobalPkgs` do NixOS já define um pacote
  concreto). Mesmo escopando o módulo só pros `homeConfigurations` standalone, foi
  descartado: Determinate Nix + Home Manager já funciona sem esse módulo há muito tempo
  (o próprio `nix.package` do Home Manager já tem `null` como default — o módulo era
  reforço redundante, não correção de bug ativo).
