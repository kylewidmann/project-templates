.PHONY: tag
tag: ##@images Tag Docker images (all packages or one: make tag <package>)
tag: registry ?= docker.io
tag:
	@for pkg_name in $(SELECTED_PKGS); do \
		pkg_version=$$(if [ -f "src/$$pkg_name/VERSION" ]; then head "src/$$pkg_name/VERSION"; else echo "dev"; fi); \
		if docker image inspect $$pkg_name:$$pkg_version > /dev/null 2>&1; then \
			echo "Tagging $$pkg_name:$$pkg_version -> $(registry)/$$pkg_name:$$pkg_version"; \
			docker tag $$pkg_name:$$pkg_version $(registry)/$$pkg_name:$$pkg_version; \
			docker tag $$pkg_name:$$pkg_version $(registry)/$$pkg_name:latest; \
		else \
			echo "Skipping $$pkg_name: image not found (run make build first)"; \
		fi; \
	done

.PHONY: push
push: ##@images Push Docker images to registry (all packages or one: make push <package>)
push: registry ?= docker.io
push:
	@for pkg_name in $(SELECTED_PKGS); do \
		pkg_version=$$(if [ -f "src/$$pkg_name/VERSION" ]; then head "src/$$pkg_name/VERSION"; else echo "dev"; fi); \
		if docker image inspect $(registry)/$$pkg_name:$$pkg_version > /dev/null 2>&1; then \
			echo "Pushing $(registry)/$$pkg_name:$$pkg_version"; \
			docker push $(registry)/$$pkg_name:$$pkg_version; \
			docker push $(registry)/$$pkg_name:latest; \
		else \
			echo "Skipping $$pkg_name: image not found (run make tag first)"; \
		fi; \
	done
