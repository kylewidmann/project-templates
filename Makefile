.PHONY: package-template
package-template: SHELL := /bin/bash
package-template:
	cd $(target) && \
	echo $$PWD && \
	SOURCE_DIR=$(basename $$PWD) ZIP=cookiecutter.zip  && \
	pushd .. && \
	zip -r $$ZIP $$SOURCE_DIR --exclude $$SOURCE_DIR/$$ZIP --quiet && \
	mv $$ZIP $$SOURCE_DIR/$$ZIP && \
	popd && \
	echo  "Cookiecutter full path: $$SOURCE_DIR/$$ZIP"

.PHONY: package
package: SHELL:=/bin/bash
package:
	for d in $(shell ls -d ./*/); do make target=$${d} package-template; done