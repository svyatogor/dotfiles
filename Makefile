SHELL := /bin/bash

.PHONY: mac devcontainer stow unstow brew-dump mise-install check list apt-install set-context show-context clear-context

PACKAGES_DIR ?= packages

# Profile detection (mac, linux, devcontainer); override with PROFILE=...
UNAME_S := $(shell uname -s)
DEFAULT_PROFILE := linux
ifeq ($(UNAME_S),Darwin)
DEFAULT_PROFILE := mac
endif
PROFILE ?= $(DEFAULT_PROFILE)

# Persisted context config
CONTEXT_FILE ?= $(HOME)/.config/dotfiles-v2/context
# If CONTEXT not provided, try reading from CONTEXT_FILE
ifeq ($(CONTEXT),)
  CONTEXT := $(shell test -f $(CONTEXT_FILE) && sed -e 's/#.*//' -e 's/^\s*//' -e 's/\s*$$//' $(CONTEXT_FILE) || echo "")
endif

# Optional context/persona (e.g., home, work). Override with CONTEXT=...
CONTEXT ?=

# Roots order: common -> profile -> context -> profile-context
ROOTS := $(PACKAGES_DIR)/common $(PACKAGES_DIR)/$(PROFILE) $(if $(CONTEXT),$(PACKAGES_DIR)/$(CONTEXT),) $(if $(CONTEXT),$(PACKAGES_DIR)/$(PROFILE)-$(CONTEXT),)

# Stow behavior flags
STOW_BASE_FLAGS ?= --dotfiles -v -R
# To enable override, set env var: STOW_OVERRIDE='.*' (or any regex)
STOW_OVERRIDE ?=
# To adopt existing files into repo (dangerous): set STOW_ADOPT=1
STOW_ADOPT ?=

mac:
	CONTEXT=$(CONTEXT) ./scripts/bootstrap-mac.sh

devcontainer:
	CONTEXT=$(CONTEXT) ./scripts/setup-devcontainer.sh

list:
	@echo "Profile: $(PROFILE)  Context: $(CONTEXT)"
	@echo "Roots: $(ROOTS)"
	@for root in $(ROOTS); do \
	  if [ -d "$$root" ]; then \
	    echo "Packages in $$root:"; \
	    for d in "$$root"/*; do [ -d "$$d" ] && basename "$$d" || true; done | xargs -n1 -I{} echo "  - {}"; \
	  fi; \
	done

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

brew-dump:
	@which brew >/dev/null 2>&1 || { echo "brew not found"; exit 1; }
	brew bundle dump --force --describe --file=./Brewfile

mise-install:
	@which mise >/dev/null 2>&1 || { echo "mise not found in PATH"; exit 1; }
	mise install

apt-install:
	@PROFILE=$(PROFILE) CONTEXT=$(CONTEXT) bash ./scripts/apt-install.sh

check:
	@$(MAKE) list
	@stow --version | head -n1 || true
	@mise --version || true

# Manage persisted context
set-context:
	@mkdir -p $(dir $(CONTEXT_FILE))
	@test -n "$(CONTEXT)" || { echo "Usage: make set-context CONTEXT=home|work"; exit 1; }
	@echo "$(CONTEXT)" > $(CONTEXT_FILE)
	@echo "Saved context: $(CONTEXT) at $(CONTEXT_FILE)"

show-context:
	@echo "Profile: $(PROFILE)"
	@echo "Context: $(CONTEXT)"
	@echo "Context file: $(CONTEXT_FILE)"

clear-context:
	@rm -f $(CONTEXT_FILE) || true
	@echo "Cleared context file: $(CONTEXT_FILE)"
