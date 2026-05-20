.PHONY: lint-local
lint-local: ##@lint Run ruff check and format check
lint-local:
	${POETRY} run ruff check ${SERVICE} tests
	${POETRY} run ruff format --check --line-length 100 ${SERVICE} tests

.PHONY: reformat
reformat: ##@local Reformat module with ruff
reformat:
	${POETRY} run ruff format --line-length 100 ${SERVICE} tests
	${POETRY} run ruff check --fix ${SERVICE} tests

.PHONY: test-local
test-local: ##@local Run test suite
test-local: venv
	${POETRY} run pytest -s --tb=native --durations=5 --cov=${SERVICE} --cov-report=html tests
	${POETRY} run coverage report --fail-under=90