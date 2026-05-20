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
- **Follow existing naming** — check neighboring files and packages for conventions
- **VERSION files are the source of truth** for package versions — update `src/<package>/VERSION` when making changes, then run `make sync-pyproject-versions`

## Package Layout

```
src/
  <package-name>/           # package directory
    <package_slug>/         # Python source (import name = package_slug)
      __init__.py
    pyproject.toml          # per-package pyproject
    VERSION                 # semver source of truth (e.g. 1.0.0)
tests/
  test_<package_slug>.py    # tests for each package
docker/
  <package-name>/
    Dockerfile              # multi-stage: base / production / development
    docker-compose.yaml
scripts/
  sync_pyproject_versions.py
```

## Development Commands

Python tooling accepts an optional **second make goal** = package directory name under `src/`. Omit it to run **every** package.

```bash
make list-packages                      # Show all packages under src/
make venv                               # Create virtual environment (poetry install)
make lint-local                         # Lint all packages with ruff
make lint-local {{cookiecutter.package_name}}  # Lint one package only
make reformat                           # Auto-fix formatting and lint issues
make reformat {{cookiecutter.package_name}}    # Reformat one package only
make test-local                         # pytest with --cov for all packages
make test-local {{cookiecutter.package_name}}  # pytest for one package
make sync-pyproject-versions            # Sync VERSION files → pyproject.toml versions
make build                              # Build Docker images for all packages
make build {{cookiecutter.package_name}}       # Build Docker images for one package
make lint                               # Lint via Docker
make test                               # Test via Docker
make ci                                 # Full CI pipeline
make help                               # List all targets
```
