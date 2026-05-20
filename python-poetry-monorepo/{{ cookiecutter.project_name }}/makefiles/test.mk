.PHONY: test
test: ##@test Run test suite via Docker (all packages or one: make test <package>)
test:
	@root_dir=$$(pwd); \
	exit_code=0; \
	for pkg_name in $(SELECTED_PKGS); do \
		if [ ! -d "src/$$pkg_name" ]; then continue; fi; \
		echo "------------------------------------------------------------"; \
		echo "Testing $$pkg_name"; \
		echo "------------------------------------------------------------"; \
		if [ -f "docker/$$pkg_name/docker-compose.yaml" ]; then \
			PROJECT=$$pkg_name docker compose -p $$pkg_name \
				-f docker/$$pkg_name/docker-compose.yaml \
				run --rm --no-deps test || exit_code=1; \
		else \
			echo "Skipping Docker test for $$pkg_name: docker/$$pkg_name/docker-compose.yaml not found"; \
		fi; \
	done; \
	exit $$exit_code
