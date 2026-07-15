---
paths:
  - "flake.nix"
  - "flake.lock"
---

# Inputs do flake

## Sem o módulo `determinate`

Não adicionar o input `determinate`
(`https://flakehub.com/f/DeterminateSystems/determinate/3`) nem seu
`homeManagerModules.default`, a menos que seja pedido explicitamente de novo — decisão já
avaliada e descartada, não um esquecimento.

- **Módulo Home Manager** (`nix.package = null`, pra não conflitar com um Determinate Nix
  já instalado): chegou a ser implementado, mas foi descartado — Determinate Nix + Home
  Manager já funciona sem esse módulo há muito tempo (o próprio `nix.package` do Home
  Manager já tem `null` como default; o módulo era reforço redundante, não correção de bug
  ativo).
