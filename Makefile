SHELL := /bin/bash

.PHONY: mac devcontainer stow unstow brew-dump mise-install check list

PACKAGES_DIR ?= packages
# Auto-discover packages as immediate subdirectories under PACKAGES_DIR
PACKAGES := $(shell [ -d $(PACKAGES_DIR) ] && for d in $(PACKAGES_DIR)/*; do [ -d $$d ] && basename $$d; done)

# Stow behavior flags
STOW_BASE_FLAGS ?= --dotfiles -v -R


mac:
	./scripts/bootstrap-mac.sh

devcontainer:
	./scripts/setup-devcontainer.sh

list:
	@echo "Discovered packages: $(PACKAGES)"

stow:
	@[ -d $(PACKAGES_DIR) ] || { echo "$(PACKAGES_DIR) not found"; exit 0; }
	@for p in $(PACKAGES); do \
		echo "stow $$p"; \
		stow -d $(PACKAGES_DIR) -t $$HOME $(STOW_BASE_FLAGS) $$p; \
	done

unstow:
	@[ -d $(PACKAGES_DIR) ] || { echo "$(PACKAGES_DIR) not found"; exit 0; }
	@for p in $(PACKAGES); do \
		echo "unstow $$p"; \
		stow -d $(PACKAGES_DIR) -t $$HOME -D $$p || true; \
	done

brew-dump:
	@which brew >/dev/null 2>&1 || { echo "brew not found"; exit 1; }
	brew bundle dump --force --describe --file=./Brewfile

mise-install:
	@which mise >/dev/null 2>&1 || { echo "mise not found in PATH"; exit 1; }
	mise install

check:
	@$(MAKE) list
	@stow --version | head -n1 || true
	@mise --version || true
