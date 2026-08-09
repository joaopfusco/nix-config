---
paths:
  - "**/*.{ts,tsx,js,jsx}"
  - "**/tsconfig.json"
---
# TypeScript / React

> Generic default. Pin version, project-specific rule in repo's own config.

- Prefer TypeScript strict; avoid `any` — use `unknown` + narrowing, or real type.
- Match repo's stack, convention (build tool, framework, styling); no mix.
- Function component + hooks. Keep component small; lift state only when need.
- Respect rules of hooks; give effect correct dependency array (no silence lint).
- Follow repo's styling approach, its ESLint/Prettier config — no impose own.

<!-- Per-repo: framework (Vite/Next/...), styling, data fetching, state mgmt, structure. -->