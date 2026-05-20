# Agent Constraints

**Read this file before making any changes.** These constraints apply to all AI-assisted work in this repository.

## Project Identity

{{cookiecutter.project_description}}

## Stack (Non-Negotiable)

- **Language**: Python 3.12+
- **Package manager**: Poetry 2.x
- **Linting/formatting**: ruff
- **Testing**: pytest, pytest-asyncio, pytest-cov

Do not introduce alternate frameworks or tools without discussion.

## Hard Rules

- **Never install a new dependency** without discussion first
- **Never commit or alter git history** without explicit human approval — including `git commit`, `git commit --amend`, rebase, or force-push. Leave changes staged for the author to review and commit
- **Run `make lint-local` and `make reformat`** before committing
- **90% test coverage target** — if you change code, add tests for it
- **No class-based tests** — use plain functions (`def test_*`) with fixtures, not `class Test*` groupings
- **Async-first** where applicable — use `async def` for I/O-bound operations; avoid blocking calls
- **One concern per module** — keep files focused; split when they grow large
- **Follow existing naming** — check neighboring files for conventions

## Package Layout

```
{{cookiecutter.project_slug}}/    # source package (import name)
tests/
  unit/
  integration/
scripts/
```

## Development Commands

```bash
make venv              # Create virtual environment (poetry install)
make lint-local        # Run ruff check + format check
make reformat          # Auto-fix formatting and lint issues
make test-local        # Run pytest with coverage (90% threshold)
make build             # Build Docker images
make lint              # Lint via Docker
make test              # Test via Docker
make ci                # Full CI pipeline
make help              # List all targets
```
