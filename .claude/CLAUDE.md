# nix-config

Configuração pessoal em Nix Flakes, só **Home Manager standalone** (sem NixOS, sem
nix-darwin — decisão deliberada, ver histórico congelado na branch `archive/nixos-support`).
Ver `README.md` na raiz do repo para estrutura, convenções de módulos (`config/` +
`default.nix`) e canais do nixpkgs — não duplicado aqui.

## Estado conhecido (2026-07-15, revalidar se desatualizado)

- `hosts/notebook` está **aplicado de verdade** na máquina principal (Dell Precision 7540,
  Ubuntu 24.04, hostname "notebook") via `home-manager switch`.
- `hosts/macbook` nunca foi aplicado de verdade — só validado via `nix flake check` / build
  a seco.
- O aviso de `GPU drivers require an update, run sudo .../non-nixos-gpu-setup` no
  `home-manager switch` do perfil notebook é ruído esperado (`targets.genericLinux.enable`);
  nenhum app gerenciado pelo nix precisa de GPU/OpenGL hoje. Não tentar "corrigir" sem um
  motivo real.

## Regras específicas

- `rules/nix-modules.md` — convenções de `programs.<app>.package` e decisões nativo-vs-nix
  por app (carrega ao mexer em `modules/`).
- `rules/flake-inputs.md` — decisões sobre inputs do flake (carrega ao mexer em
  `flake.nix`/`flake.lock`).
