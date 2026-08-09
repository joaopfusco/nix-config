---
paths:
  - "**/*_test.go"
  - "**/test_*.py"
  - "**/*_test.py"
  - "**/*.{test,spec}.*"
  - "**/*Test.cs"
  - "**/*Tests.cs"
  - "**/{test,tests,__tests__}/**"
---
# Testing (universal)

## Philosophy

- Test behavior + contract, no implementation detail.
- Test fail for one reason only; name after what it assert.
- Cover happy path, edge (empty/zero/nil, boundary), failure mode.
- No chase coverage number — cover what actually break.

## Structure

- Arrange–Act–Assert (given/when/then). One logical assertion per test.
- Table-driven / parametrized test for many similar case.
- Tests independent, order-free; no shared mutable state between them.
- Use lang's idiomatic layout (e.g. `_test.go` beside source, `tests/` for
  Python, `*.test.ts` beside source, dedicated test project for .NET).

## Doubles

- Prefer real implementation; fake only at true boundary (network, clock, fs, DB).
- No mock what you no own — wrap it, mock wrapper instead.
- Use spun-up infra (Docker Compose / testcontainers) over mock when integration
  behavior is what's under test.

## Discipline

- Bug fix come with test fail before fix, pass after.
- No weaken assertion to make test pass — fix code or expectation.
- Keep tests fast; isolate slow/integration test so default run stay quick.