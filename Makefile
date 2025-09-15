## Dotfiles Makefile
##
## Variables you can override per invocation:
##  - PROFILE:   mac | linux | devcontainer (auto-detected by default)
##  - CONTEXT:   home | work (optional persona layer; can be persisted)
##  - STOW_OVERRIDE: regex for stow --override to resolve intra-package conflicts
##  - STOW_ADOPT:   set to non-empty to pass --adopt (pulls files into repo; use with care)
##
SHELL := /bin/bash

.PHONY: bootstrap mac devcontainer stow unstow brew brew-dump mise-install check list apt-install set-context show-context clear-context

.DEFAULT_GOAL := bootstrap

## Root directory for stow packages
PACKAGES_DIR ?= packages

## Profile detection (override with PROFILE=...)
UNAME_S := $(shell uname -s)
DEFAULT_PROFILE := linux
ifeq ($(UNAME_S),Darwin)
DEFAULT_PROFILE := mac
endif
PROFILE ?= $(DEFAULT_PROFILE)

BOOTSTRAP_TARGETS := stow mise-install
ifeq ($(PROFILE),mac)
BOOTSTRAP_TARGETS := brew stow mise-install
endif
ifeq ($(PROFILE),devcontainer)
BOOTSTRAP_TARGETS := devcontainer stow mise-install
endif

bootstrap:
	@for target in $(BOOTSTRAP_TARGETS); do \
	  echo "==> make $$target"; \
	  $(MAKE) $$target; \
	done

## Persisted context config file (used if CONTEXT not provided)
CONTEXT_FILE ?= $(HOME)/.config/dotfiles-v2/context
## If CONTEXT not provided, try reading from CONTEXT_FILE
ifeq ($(CONTEXT),)
  CONTEXT := $(shell test -f "$(CONTEXT_FILE)" && sed 's/\#.*//; s/^[[:space:]]*//; s/[[:space:]]*$$//' "$(CONTEXT_FILE)")
endif

## Optional context/persona (e.g., home, work). Override with CONTEXT=...
CONTEXT ?=

## Stow roots order: common -> profile -> context -> profile-context
ROOTS := $(PACKAGES_DIR)/common $(PACKAGES_DIR)/$(PROFILE) $(if $(CONTEXT),$(PACKAGES_DIR)/$(CONTEXT),) $(if $(CONTEXT),$(PACKAGES_DIR)/$(PROFILE)-$(CONTEXT),)

## Stow behavior flags
STOW_BASE_FLAGS ?= --dotfiles
## To enable override, set env var: STOW_OVERRIDE='.*' (or any regex)
STOW_OVERRIDE ?=
## To adopt existing files into repo (dangerous): set STOW_ADOPT=1
STOW_ADOPT ?=

## mac: bootstrap macOS (Homebrew bundle + cleanup) and stow packages
mac:
	CONTEXT=$(CONTEXT) ./scripts/bootstrap-mac.sh

## brew: install Homebrew if needed and run brew bundle/cleanup
brew:
	@CONTEXT=$(CONTEXT) ./scripts/brew-install.sh

## devcontainer: install apt packages declaratively and stow for containers
devcontainer:
	CONTEXT=$(CONTEXT) ./scripts/setup-devcontainer.sh

## list: show active profile, context, and discovered packages per root
list:
	@echo "Profile: $(PROFILE)  Context: $(CONTEXT)"
	@echo "Roots: $(ROOTS)"
	@for root in $(ROOTS); do \
	  if [ -d "$$root" ]; then \
	    echo "Packages in $$root:"; \
	    for d in "$$root"/*; do [ -d "$$d" ] && basename "$$d" || true; done | xargs -n1 -I{} echo "  - {}"; \
	  fi; \
	done

## stow: link all packages from each root into the home directory
stow:
	@for root in $(ROOTS); do \
	  if [ -d "$$root" ]; then \
	    echo "Stowing from $$root"; \
	    for d in "$$root"/*; do \
	      if [ -d "$$d" ]; then \
	        p=$$(basename "$$d"); \
	        echo "  stow $$p"; \
	        stow -d "$$root" -t $$HOME $(STOW_BASE_FLAGS) $(if $(STOW_OVERRIDE),--override=$(STOW_OVERRIDE),) $(if $(STOW_ADOPT),--adopt,) "$$p"; \
	      fi; \
	    done; \
	  fi; \
	done

## unstow: remove symlinks created by stow for all packages
unstow:
	@for root in $(ROOTS); do \
	  if [ -d "$$root" ]; then \
	    echo "Unstowing from $$root"; \
	    for d in "$$root"/*; do \
	      if [ -d "$$d" ]; then \
	        p=$$(basename "$$d"); \
	        echo "  unstow $$p"; \
	        stow -d "$$root" -t $$HOME -D "$$p" || true; \
	      fi; \
	    done; \
	  fi; \
	done

## brew-dump: regenerate root Brewfile from current system
brew-dump:
	@which brew >/dev/null 2>&1 || { echo "brew not found"; exit 1; }
	brew bundle dump --force --describe --file=./Brewfile

## mise-install: install tools defined in mise config.toml
mise-install:
	@which mise >/dev/null 2>&1 || { echo "mise not found in PATH"; exit 1; }
	mise install

## apt-install: install apt packages from profile/context lists
apt-install:
	@PROFILE=$(PROFILE) CONTEXT=$(CONTEXT) bash ./scripts/apt-install.sh

## check: quick diagnostics and version checks
check:
	@$(MAKE) list
	@stow --version | head -n1 || true
	@mise --version || true

## set-context: persist CONTEXT to a file so future runs remember it
set-context:
	@mkdir -p $(dir $(CONTEXT_FILE))
	@test -n "$(CONTEXT)" || { echo "Usage: make set-context CONTEXT=home|work"; exit 1; }
	@echo "$(CONTEXT)" > $(CONTEXT_FILE)
	@echo "Saved context: $(CONTEXT) at $(CONTEXT_FILE)"

## show-context: display the active profile, context, and config path
show-context:
	@echo "Profile: $(PROFILE)"
	@echo "Context: $(CONTEXT)"
	@echo "Context file: $(CONTEXT_FILE)"

## clear-context: remove persisted context file
clear-context:
	@rm -f $(CONTEXT_FILE) || true
	@echo "Cleared context file: $(CONTEXT_FILE)"
