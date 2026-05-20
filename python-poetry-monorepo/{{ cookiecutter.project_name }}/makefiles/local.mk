.PHONY: lint-local
lint-local: ##@lint Run ruff check + format check locally (all packages or one: make lint-local <package>)
lint-local:
	@echo "Linting: $(SELECTED_PKGS)"; \
	root_dir=$$(pwd); \
	exit_code=0; \
	for pkg_name in $(SELECTED_PKGS); do \
		if [ ! -d "src/$$pkg_name" ]; then continue; fi; \
		pkg_slug=$$(echo $$pkg_name | tr '-' '_'); \
		echo "------------------------------------------------------------"; \
		echo "Linting $$pkg_name"; \
		echo "------------------------------------------------------------"; \
		${POETRY} run ruff check src/$$pkg_name/$$pkg_slug || exit_code=1; \
		${POETRY} run ruff format --check --line-length 100 src/$$pkg_name/$$pkg_slug || exit_code=1; \
	done; \
	exit $$exit_code

.PHONY: reformat
reformat: ##@local Reformat with ruff (all packages or one: make reformat <package>)
reformat:
	@echo "Reformatting: $(SELECTED_PKGS)"; \
	for pkg_name in $(SELECTED_PKGS); do \
		if [ ! -d "src/$$pkg_name" ]; then continue; fi; \
		pkg_slug=$$(echo $$pkg_name | tr '-' '_'); \
		echo "------------------------------------------------------------"; \
		echo "Reformatting $$pkg_name"; \
		echo "------------------------------------------------------------"; \
		${POETRY} run ruff format --line-length 100 src/$$pkg_name/$$pkg_slug; \
		${POETRY} run ruff check --fix src/$$pkg_name/$$pkg_slug; \
	done

.PHONY: test-local
test-local: ##@local Run test suite locally (all packages or one: make test-local <package>)
test-local: venv
	@echo "Testing: $(SELECTED_PKGS)"; \
	${POETRY} run pytest -s --tb=native --durations=5 $(COV_ARGS) --cov-report=html tests; \
	${POETRY} run coverage report --fail-under=90
