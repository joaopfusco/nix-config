# Django project architecture

My preferred structure for Django backends. Reference:
[HackSoftware/Django-Styleguide](https://github.com/HackSoftware/Django-Styleguide)
(business logic in a services/selectors layer, thin views). This captures the **structure and
layering**, not any one project's stack — the API framework (django-ninja vs DRF), admin
theme, auth, storages, and i18n are per-repo choices, not global defaults.

## Project package + split settings

- Name the project package `config/` (not `<projectname>/`): it holds `urls.py`, `asgi.py`,
  `wsgi.py`, and the API assembly.
- **Split settings** under `config/settings/`, composed by `__init__.py`:

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

- Env via `.env`; parse `DATABASE_URL` with dj-database-url; secrets from `os.environ`,
  never hardcoded.

## Apps as feature folders

- One app per bounded feature (`accounts`, `content`, …), plus a `common` app for shared base
  models / mixins / schemas.
- **Small app** = flat modules (`models.py`, `admin.py`, `apps.py`, the API module, `schemas.py`).
- **Large app** = packages: explode `models/`, `admin/`, and the API layer into packages with
  one file per entity (`content/models/news.py`, `content/admin/news.py`, …) plus an
  `__init__.py` that re-exports. Split by entity, not by layer.

## API layer — framework is a per-repo choice

Keep the HTTP layer separate from models; pick the framework per project:

- **django-ninja** — routers + pydantic schemas, assembled into a `NinjaAPI` in `config/api.py`.
- **DRF** — serializers + views/viewsets + routers, wired from `config/urls.py`.

Either way, business logic lives in a **service/selector layer** (HackSoft style — services
write, selectors read), not in fat views/routers or fat models. The HTTP layer stays thin.

## Deploy shape (when containerized)

- Multi-stage Dockerfile: a builder stage installs deps and compiles i18n catalogs; a slim
  runtime stage copies the built venv.
- `entrypoint.sh` runs `migrate` + `collectstatic`, then `exec "$@"`.
- Compose brings up Postgres + the app; serve with gunicorn/uvicorn workers.
