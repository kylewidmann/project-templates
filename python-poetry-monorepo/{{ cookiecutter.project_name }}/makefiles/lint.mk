.PHONY: lint
lint: ##@lint Run ruff lint + format check via Docker (all packages or one: make lint <package>)
lint:
	@root_dir=$$(pwd); \
	exit_code=0; \
	for pkg_name in $(SELECTED_PKGS); do \
		if [ ! -d "src/$$pkg_name" ]; then continue; fi; \
		pkg_slug=$$(echo $$pkg_name | tr '-' '_'); \
		echo "------------------------------------------------------------"; \
		echo "Linting $$pkg_name"; \
		echo "------------------------------------------------------------"; \
		if [ -f "docker/$$pkg_name/docker-compose.yaml" ]; then \
			PROJECT=$$pkg_name docker compose -p $$pkg_name \
				-f docker/$$pkg_name/docker-compose.yaml \
				run --rm --no-deps lint \
				ruff check src/$$pkg_name/$$pkg_slug || exit_code=1; \
			PROJECT=$$pkg_name docker compose -p $$pkg_name \
				-f docker/$$pkg_name/docker-compose.yaml \
				run --rm --no-deps lint \
				ruff format --check --line-length 100 src/$$pkg_name/$$pkg_slug || exit_code=1; \
		else \
			echo "Skipping Docker lint for $$pkg_name: docker/$$pkg_name/docker-compose.yaml not found"; \
		fi; \
	done; \
	exit $$exit_code
