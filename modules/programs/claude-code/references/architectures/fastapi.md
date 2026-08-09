# FastAPI project architecture

My preferred layout for FastAPI services. Reference:
[zhanymkanov/fastapi-best-practices](https://github.com/zhanymkanov/fastapi-best-practices)
(Netflix Dispatch-inspired). This captures the **structure**, not any one project's stack —
the auth provider, database, and domain modules vary per repo.

## Layout

Flat, domain-folder style under a `src/` package (no `core/`/`modules/` wrapper):

```
alembic.ini            # at repo root, script_location -> alembic/
alembic/               # migrations (async template), versions in alembic/versions/
src/
  main.py              # builds the FastAPI app, mounts the top router — run as `python -m src.main`
  router.py            # assembles api_router from the domain routers
  config.py            # single settings source (pydantic-settings, reads .env)
  database.py          # engine, Base, get_db session dependency
  exceptions.py        # shared HTTPException bases (NotFound, PermissionDenied, BadRequest, Unauthorized)
  <domain>/            # one folder per domain (users, orders, …)
    router.py          # routes only; thin
    service.py         # business logic as plain async functions
    schemas.py         # pydantic request/response models
    models.py          # SQLAlchemy 2.0 models for tables this domain owns
    dependencies.py    # reusable per-route validation (valid_<name>_id → Depends)
    exceptions.py      # domain exceptions inheriting from src/exceptions.py
```

## Conventions

- **Functional service layer**: `service.py` holds async functions querying via SQLAlchemy
  2.0 `select()`. No repository classes, no generic `Base[ModelType]` — a deliberate choice
  over the generic-base-class boilerplate some FastAPI templates use.
- **Config centralized**: all env goes through `Settings` in `config.py`; no ad-hoc
  `os.getenv()` scattered around.
- **`src/` is the package, `main.py` lives inside it** — run it as a module
  (`python -m src.main`) or a `[project.scripts]` entry point, never `python src/main.py`
  (a script's own dir becomes `sys.path[0]`, so `src.*` imports break).
- **A module omits files it doesn't need**: an auth module backed by an external IdP has no
  `models.py`; a read-only module is just `schemas.py` + `router.py`.

## Tooling

- `uv` for dependencies. Keep a `[build-system]` (hatchling) so `[project.scripts]` entry
  points materialize under `uv run <script>` — without it `uv run <name>` fails.
- Alembic lives at the repo root (`alembic.ini` + `alembic/`, sibling to `src/`), matching
  `alembic init`. Run migrations from the root, or `env.py`'s `src.*` imports break.
- Don't invent lint/test commands until the repo actually adopts a linter/test framework.

## Gotchas

- Compiled deps (numpy/pandas/scikit-learn) under Nix/devenv need shared libs set explicitly
  or they fail on `libz.so.1` — see `rules/dev-environments.md`.
