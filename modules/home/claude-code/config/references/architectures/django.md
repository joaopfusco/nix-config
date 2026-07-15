# Django project architecture

My preferred structure Django backend. Reference:
[HackSoftware/Django-Styleguide](https://github.com/HackSoftware/Django-Styleguide)
(business logic in services/selectors layer, thin views). Capture **structure and
layering**, not one project's stack — API framework (django-ninja vs DRF), admin
theme, auth, storage, i18n per-repo choice, not global default.

## Project package + split settings

- Name project package `config/` (not `<projectname>/`): hold `urls.py`, `asgi.py`,
  `wsgi.py`, API assembly.
- **Split settings** under `config/settings/`, compose by `__init__.py`:

```
config/
  settings/
    __init__.py   # from .base import *; from .auth import *; from .storage import *; …
    base.py       # apps, middleware, database (dj-database-url), i18n, static
    <concern>.py  # auth, storage, logging, … one file per concern
  urls.py
  api.py          # API surface assembly (see below)
  asgi.py / wsgi.py
```

- Env via `.env`; parse `DATABASE_URL` with dj-database-url; secret from `os.environ`,
  never hardcode.

## Apps as feature folders

- One app per bounded feature (`accounts`, `content`, …), plus `common` app for shared base
  model / mixin / schema.
- **Small app** = flat module (`models.py`, `admin.py`, `apps.py`, API module, `schemas.py`).
- **Large app** = package: explode `models/`, `admin/`, API layer into package, one file per entity
  (`content/models/news.py`, `content/admin/news.py`, …) plus `__init__.py` re-export.
  Split by entity, not layer.

## API layer — framework per-repo choice

Keep HTTP layer separate from model; pick framework per project:

- **django-ninja** — router + pydantic schema, assemble into `NinjaAPI` in `config/api.py`.
- **DRF** — serializer + view/viewset + router, wire from `config/urls.py`.

Either way, business logic live in **service/selector layer** (HackSoft style — service
write, selector read), not fat view/router or fat model. HTTP layer stay thin.

## Deploy shape (when containerized)

- Multi-stage Dockerfile: builder stage install dep + compile i18n catalog; slim
  runtime stage copy built venv.
- `entrypoint.sh` run `migrate` + `collectstatic`, then `exec "$@"`.
- Compose bring up Postgres + app; serve gunicorn/uvicorn worker.