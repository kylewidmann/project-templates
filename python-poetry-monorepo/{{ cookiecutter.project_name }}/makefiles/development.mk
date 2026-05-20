.PHONY: venv
venv: ##@development Set up virtual environment
venv:
	${POETRY} install

.PHONY: build
build: ##@development Build Docker images (all packages or one: make build <package>)
build: args ?= --network=host --build-arg BUILDKIT_INLINE_CACHE=1
build:
	@for pkg_name in $(SELECTED_PKGS); do \
		image_dir="docker/$$pkg_name"; \
		pkg_version=$$(if [ -f "src/$$pkg_name/VERSION" ]; then head "src/$$pkg_name/VERSION"; else echo "dev"; fi); \
		if [ ! -f "$$image_dir/Dockerfile" ]; then \
			echo "Skipping $$pkg_name: $$image_dir/Dockerfile not found"; \
			continue; \
		fi; \
		echo "Building images for $$pkg_name (version: $$pkg_version)"; \
		dockerfile="$$image_dir/Dockerfile"; \
		available_targets=$$(grep -i "^FROM.*AS" $$dockerfile | sed 's/.*AS[[:space:]]*\([^[:space:]]*\).*/\1/' | tr '[:upper:]' '[:lower:]' || echo "production development"); \
		for stage_target in $$available_targets; do \
			if [[ "$$stage_target" == production* ]]; then \
				image_name="$$pkg_name"; \
				echo "Building $$stage_target -> $$image_name:$$pkg_version"; \
				DOCKER_BUILDKIT=1 docker build --progress=plain --target $$stage_target \
					-f $$dockerfile \
					-t $$image_name:${BRANCH_NAME}-${BUILD_NUMBER} \
					-t $$image_name:$$pkg_version \
					--build-arg PROJECT_DIR=$$pkg_name \
					--build-arg PROJECT=$$pkg_name \
					${args} .; \
			elif [[ "$$stage_target" == development* ]]; then \
				image_name="$${pkg_name}_dev"; \
				echo "Building $$stage_target -> $$image_name:$$pkg_version"; \
				DOCKER_BUILDKIT=1 docker build --progress=plain --target $$stage_target \
					-f $$dockerfile \
					-t $$image_name:${BRANCH_NAME}-${BUILD_NUMBER} \
					-t $$image_name:$$pkg_version \
					--build-arg PROJECT_DIR=$$pkg_name \
					--build-arg PROJECT=$$pkg_name \
					--cache-from $$pkg_name:${BRANCH_NAME}-${BUILD_NUMBER} \
					${args} .; \
			fi; \
		done; \
	done

.PHONY: infrastructure
infrastructure: ##@development Set up infrastructure for tests
infrastructure:
	@echo "Skipping..."

.PHONY: clean
clean: ##@development Clean up Docker resources
clean:
	@echo "Skipping..."

.PHONY: sync-pyproject-versions
sync-pyproject-versions: ##@development Sync VERSION files into pyproject.toml for each package under src/
sync-pyproject-versions:
	${POETRY} run python scripts/sync_pyproject_versions.py

.PHONY: list-packages
list-packages: ##@development List all packages under src/
	@echo "Available packages:"
	@for pkg in $(PACKAGES); do echo "  - $$pkg"; done

.PHONY: ci
ci: ##@development Run full CI pipeline
ci: clean build infrastructure lint test clean
