.PHONY: lint
lint: ##@lint Run ruff check and format check (via Docker)
lint:
	${DC} run --rm --no-deps lint ruff check ${SERVICE} tests
	${DC} run --rm --no-deps lint ruff format --check --line-length 100 ${SERVICE} tests