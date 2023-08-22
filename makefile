.DEFAULT_GOAL := help

.PHONY: help release

help:
	@echo "Usage: make release [name=<package_name>] [version=<release_version>]"
	@echo ""
	@echo "Example:"
	@echo "  make release name=your_package_name version=1.0.0"

release:
	@if [ -z "$(name)" ]; then \
		echo "Error: 'name' parameter is required."; \
		exit 1; \
	fi
	@if [ -z "$(version)" ]; then \
		echo "Error: 'version' parameter is required."; \
		exit 1; \
	fi
	git checkout main
	git pull -r origin main
	git switch -c release/$(name)/$(version)
	cd packages/${name}; \
		npm version $(version) --no-git-tag-version
	git add --all
	git commit -am "release($(name)): $(version)"
	git rebase develop
	git rebase main
	git push -u origin release/$(name)/$(version)
