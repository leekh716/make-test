.DEFAULT_GOAL := help

.PHONY: help release

RED = \033[0;31m
GREEN = \033[0;32m
YELLOW = \033[0;33m
BLUE = \033[0;34m
PURPLE = \033[1;35m
CYAN = \033[0;36m
WHITE = \033[0;37m
RESET = \033[0m

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
	git checkout develop
	git pull -r origin develop
	git checkout main
	git pull -r origin main
	git switch -c release/$(name)/$(version)
	cd packages/${name}; \
		npm version $(version) --no-git-tag-version
	git add --all
	git commit -am "release($(name)): $(version)"
	git rebase develop
	@echo "$(PURPLE)git rebase develop$(RESET) $(WHITE)succeeded!$(RESET)"
	git rebase main
	@echo "$(PURPLE)git rebase main$(RESET) $(WHITE)succeeded!$(RESET)"
	git push -u origin release/$(name)/$(version)
	@echo "$(PURPLE)release/$(name)/$(version)$(RESET) $(WHITE)branch is pushed!$(RESET)"
