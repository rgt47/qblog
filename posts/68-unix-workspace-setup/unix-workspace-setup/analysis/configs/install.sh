#!/bin/bash
# install.sh — deploy dotfiles into $HOME via symlinks.
# Idempotent: existing files are backed up with a timestamp
# suffix before being replaced.
#
# Usage:
#   ./install.sh            # deploy
#   ./install.sh --dry-run  # preview all actions without executing
set -euo pipefail

DRY_RUN=0
[[ "${1:-}" == "--dry-run" ]] && DRY_RUN=1

DOTFILES="$(cd "$(dirname "$0")/../.." && pwd)"

log()      { echo "[INFO]  $*"; }
warn()     { echo "[WARN]  $*" >&2; }
dry_run()  { [[ $DRY_RUN -eq 1 ]] && echo "[DRY]   $*" || "$@"; }

link_file() {
  local src="$1" dest="$2"
  if [ -e "$dest" ] && [ ! -L "$dest" ]; then
    warn "$dest exists, creating backup"
    dry_run mv "$dest" "${dest}.backup.$(date +%Y%m%d_%H%M%S)"
  fi
  dry_run mkdir -p "$(dirname "$dest")"
  dry_run ln -sfn "$src" "$dest"
  log "Linked $src -> $dest"
}

# -- Shell ------------------------------------------------------------------
link_file "$DOTFILES/shell/zshrc"   "$HOME/.zshrc"
link_file "$DOTFILES/shell/zshenv"  "$HOME/.zshenv"
link_file "$DOTFILES/shell/inputrc" "$HOME/.inputrc"

# -- Git --------------------------------------------------------------------
link_file "$DOTFILES/git/gitconfig"        "$HOME/.gitconfig"
link_file "$DOTFILES/git/gitignore_global" "$HOME/.gitignore_global"

# -- Editor -----------------------------------------------------------------
link_file "$DOTFILES/editors/vimrc" "$HOME/.config/vim/vimrc"

# -- XDG configs (one link per tool directory) ------------------------------
for d in "$DOTFILES"/config/*/; do
  name="$(basename "$d")"
  link_file "$d" "$HOME/.config/$name"
done

# -- ~/bin: per-file symlinks (not a top-level directory link) --------------
dry_run mkdir -p "$HOME/bin"
for f in "$DOTFILES"/bin/*; do
  link_file "$f" "$HOME/bin/$(basename "$f")"
done

# -- launchd plists (macOS only; substitute __USER__ placeholder) -----------
if [[ "$(uname)" == "Darwin" ]]; then
  dry_run mkdir -p "$HOME/Library/LaunchAgents"
  for plist in "$DOTFILES"/launchd/*.plist; do
    name="$(basename "$plist")"
    target="$HOME/Library/LaunchAgents/$name"
    if [[ $DRY_RUN -eq 1 ]]; then
      echo "[DRY]   sed s/__USER__/$USER/g $plist > $target"
    else
      sed "s|__USER__|$USER|g" "$plist" > "$target"
    fi
    log "Installed $target"
  done
fi

# -- Homebrew packages ------------------------------------------------------
if command -v brew > /dev/null 2>&1; then
  if [ -f "$DOTFILES/packages/Brewfile" ]; then
    dry_run brew bundle --file="$DOTFILES/packages/Brewfile"
  fi
fi

# -- pipx tools -------------------------------------------------------------
if command -v pipx > /dev/null 2>&1; then
  if [ -f "$DOTFILES/packages/pipx-tools.txt" ]; then
    while read -r tool; do
      [[ -z "$tool" || "$tool" =~ ^# ]] && continue
      dry_run pipx install --force "$tool"
    done < "$DOTFILES/packages/pipx-tools.txt"
  fi
fi

log "Install complete."
log ""
log "Manual steps required on this machine:"
log "  1. Restore ~/.ssh from secure storage"
log "  2. Restore ~/.aws from secure storage (if needed)"
log "  3. Restore ~/.gnupg from secure storage (if needed)"
log "  4. Run: gh auth login"
if [[ "$(uname)" == "Darwin" ]]; then
  log "  5. Load launchd agents:"
  log "       launchctl bootstrap gui/\$UID \\"
  log "         ~/Library/LaunchAgents/*.plist"
fi
log "  6. Restart shell: source ~/.zshrc"
