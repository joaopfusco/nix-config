---
paths:
  - "**/*.go"
  - "**/go.mod"
---
# Go

> Generic default. Pin version, project-specific rule go in repo own config.

- Use standard toolchain (`go build/test ./...`, `go vet`, `gofmt`).
- Errors: return, wrap `fmt.Errorf("...: %w", err)`; no panic in library code.
- Accept `context.Context` first arg anything do I/O; honor cancellation.
- Prefer stdlib (`net/http`, `log/slog`, `encoding/json`) before reach for dep.
- Keep interface small, define by consumer, not producer.
- Concurrency: no leak goroutine; each got clear exit path (ctx/channel close).

<!-- Per-repo: Go version, module layout, router/lib choice, lint config. -->