---
paths:
  - "**/*.py"
  - "**/pyproject.toml"
---
# Python

> Generic default. Pin version, project-specific rule in repo's own config.

- `pyproject.toml` source of truth for deps, tooling when present.
- Type-hint public function; keep clean under repo's type checker.
- Follow repo's formatter/linter (e.g. ruff/black) — no impose one it lack.
- Prefer `pathlib`, dataclass / typed model, explicit over clever.
- Use project's virtualenv / dev shell — no install package globally.
- Raise specific exception; never bare `except:`. Use context manager for resource.

<!-- Per-repo: Python version, web framework, async convention, package manager. -->