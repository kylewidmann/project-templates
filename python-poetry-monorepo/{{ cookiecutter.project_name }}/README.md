# {{cookiecutter.project_name}}

{{cookiecutter.project_description}}

## Repository Structure

```
src/                          # Python packages
  {{cookiecutter.package_name}}/
    {{cookiecutter.package_slug}}/
    pyproject.toml
    VERSION
docker/                       # Per-package Dockerfiles and compose files
  {{cookiecutter.package_name}}/
    Dockerfile
    docker-compose.yaml
tests/                        # Tests for all packages
makefiles/                    # Modular Makefile includes
scripts/                      # Repository utilities
```

## Getting Started

```bash
# Set up virtual environment
make venv

# Run lint checks
make lint-local

# Run tests
make test-local

# See all available targets
make help
```

## Adding a New Package

1. Create `src/<package-name>/` with a `pyproject.toml`, `VERSION`, and source directory
2. Add the package as a path dependency in the root `pyproject.toml`
3. Run `make venv` to reinstall
4. Add a `docker/<package-name>/Dockerfile` if the package needs a Docker image
5. Add tests under `tests/`
