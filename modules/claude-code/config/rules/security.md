# Security (universal)

## Secrets

- No hardcode secret. Read from env / secret manager; commit `.env.example`
  with placeholder value only.
- No log secret, token, or full PII. Redact before log.
- Secret exposed → rotate it. Remove from diff not enough.

## Input & output

- Treat external input hostile: validate type, range, length, format.
- Parameterized query / ORM binding only — never build SQL by string concat.
- Encode output for its sink (HTML escape, shell quoting) stop injection/XSS.
- Validate redirect target and file path against allowlist; reject traversal.

## Auth

- Authentication ≠ authorization — check both, and check authz every request
  for specific resource, not just "is logged in".
- Hash password with slow KDF (argon2/bcrypt/scrypt); never reversible encryption.
- Scope token, set expiry, prefer short-lived + refresh over long-lived token.

## Dependencies & transport

- Pin/lock dependency; review before add. Prefer maintained, minimal lib.
- TLS everywhere; verify cert — never disable verify to "make it work".
- Keep error response generic to client; keep detail in server-side log.

## Defaults

- Least privilege for DB user, service account, container capability, token.
- Deny by default; allow explicit.