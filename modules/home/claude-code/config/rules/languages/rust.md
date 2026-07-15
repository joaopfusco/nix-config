---
paths:
  - "**/*.rs"
  - "**/Cargo.toml"
---
# Rust

> Generic default. Pin version, project-specific rule live repo own config.

- Use project toolchain (`cargo build/test`, `rustfmt`, `clippy`); keep clippy clean.
- Prefer `Result` + `?` over `unwrap()`/`expect()`/`panic!`, except truly unrecoverable init.
- Model invariant in type system; make illegal state unrepresentable.
- Borrow over clone; reach for `Rc`/`Arc`/`Mutex` deliberate, no reflex.
- Keep `unsafe` minimal, isolated, documented with safety invariant.
- For embedded / `no_std` target, mind heap/stack limit; build through
  project toolchain — no assume host `cargo build`. Treat vendored/generated
  tree (e.g. `.embuild/`) read-only.

<!-- Per-repo: edition, target (host vs embedded), key crate, HAL/runtime convention. -->