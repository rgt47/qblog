.PHONY: install update lint test backup help

DOTFILES := $(shell cd ../.. && pwd)

help:
	@echo "Targets:"
	@echo "  install   create symlinks; install Homebrew and pipx packages"
	@echo "  update    git pull, then re-run install.sh"
	@echo "  lint      shellcheck bin/; zsh -n on shell files"
	@echo "  test      install.sh --dry-run, then lint"
	@echo "  backup    snapshot current dotfiles from HOME"

install:
	$(DOTFILES)/install.sh

update:
	git -C $(DOTFILES) pull origin main
	$(DOTFILES)/install.sh

lint:
	@if command -v shellcheck > /dev/null 2>&1; then \
	  find $(DOTFILES)/bin -type f -name '*.sh' \
	    -exec shellcheck {} \; ; \
	else \
	  echo "[SKIP] shellcheck not installed"; \
	fi
	@find $(DOTFILES)/shell -type f \
	  -exec zsh -n {} \; 2>&1 \
	  | grep -v '^$$' || true

test:
	$(DOTFILES)/install.sh --dry-run
	$(MAKE) lint

backup:
	@d=$(DOTFILES)/backups/$$(date +%Y%m%d-%H%M%S) \
	  && mkdir -p "$$d" \
	  && for f in .zshrc .zshenv .gitconfig .inputrc .vimrc; do \
	       [ -e "$$HOME/$$f" ] && cp "$$HOME/$$f" "$$d/" || true; \
	     done \
	  && echo "Backup written to $$d"
