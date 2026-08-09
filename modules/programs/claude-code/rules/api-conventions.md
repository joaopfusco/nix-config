---
paths:
  - "**/{api,apis,handlers,controllers,routes,endpoints,resources}/**"
  - "**/*.proto"
  - "**/openapi*.{yml,yaml,json}"
  - "**/swagger*.{yml,yaml,json}"
---
# API conventions (universal, HTTP/REST)

## Resources & verbs

- Nouns for resource, plural: `/users`, `/orders/{id}/items`.
- Verb come from HTTP: `GET` (read, safe), `POST` (create), `PUT`/`PATCH`
  (replace/partial update), `DELETE` (remove). No verb in path.
- `GET` and `DELETE` carry no body; mutation validate before any side effect.

## Status codes

- `200` ok, `201` created (+ `Location`), `204` no content.
- `400` validation, `401` unauthenticated, `403` unauthorized, `404` not found,
  `409` conflict, `422` semantic validation, `429` rate-limited.
- `5xx` only for real server fault — never signal client mistake.

## Payloads

- JSON, casing consistent across API (pick `camelCase` or `snake_case`, stick it).
- Error share one shape: machine code, human message, optional field detail.
  Never return stack trace or raw DB error to client.
- Timestamp UTC ISO-8601; money integer minor unit or decimal string,
  never float.

## Behavior

- Validate and authenticate at edge; assume all input hostile.
- Paginate list endpoint by default; never return unbounded collection.
- Make write idempotent where feasible; document idempotency key when used.
- Version when breaking (`/v1`); add field backward-compatibly, no repurpose.
- Document with OpenAPI; spec and implementation no drift.