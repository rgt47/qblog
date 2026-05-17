#!/usr/bin/env bash
# Add sensitive directories to dotfiles .gitignore before git init.
# Run from the dotfiles root directory.
# Usage: bash gitignore-guard.sh
set -euo pipefail

GITIGNORE=".gitignore"

entries=(
  ".password-store"
  ".gnupg"
  ".ssh"
  ".aws"
  "secrets/*"
  "!secrets/README.md"
)

for entry in "${entries[@]}"; do
  if ! grep -qF "$entry" "$GITIGNORE" 2>/dev/null; then
    echo "$entry" >> "$GITIGNORE"
    echo "Added:           $entry"
  else
    echo "Already present: $entry"
  fi
done

echo ""
echo "Review $GITIGNORE, then: git add .gitignore && git commit -m 'guard sensitive dirs'"
