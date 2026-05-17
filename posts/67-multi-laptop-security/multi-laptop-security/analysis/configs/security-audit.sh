#!/usr/bin/env bash
# Quarterly security audit for a multi-laptop research cluster.
# Run on each machine. Exits non-zero if any check fails.
# Usage: bash security-audit.sh
set -euo pipefail

PASS=0
FAIL=0
SKIP=0

ok()   { echo "  PASS  $1"; PASS=$((PASS + 1)); }
fail() { echo "  FAIL  $1"; FAIL=$((FAIL + 1)); }
skip() { echo "  SKIP  $1"; SKIP=$((SKIP + 1)); }

echo "=== Security audit: $(hostname) at $(date) ==="
echo ""

# 1. FileVault
echo "-- Disk --"
fv=$(fdesetup status 2>/dev/null || echo "")
if echo "$fv" | grep -q "FileVault is On"; then
  ok "FileVault enabled"
else
  fail "FileVault enabled (run: sudo fdesetup enable)"
fi

# 2. Screen lock timeout (<= 60 s)
delay=$(defaults read com.apple.screensaver askForPasswordDelay 2>/dev/null || echo "999")
if [[ "$delay" -le 60 ]]; then
  ok "Screen lock timeout ${delay}s (<= 60s)"
else
  fail "Screen lock timeout ${delay}s (set <= 60s in System Settings -> Lock Screen)"
fi

# 3. GPG key expiry warning (manual review)
echo ""
echo "-- GPG (review expiry dates) --"
gpg --list-keys --with-colons 2>/dev/null | grep "^pub" | while IFS=: read -r _ _ _ _ _ _ _ _ _ expiry _; do
  if [[ -n "$expiry" && "$expiry" != "0" ]]; then
    days_left=$(( (expiry - $(date +%s)) / 86400 ))
    if [[ "$days_left" -lt 90 ]]; then
      fail "GPG key expires in ${days_left} days -- renew now"
    else
      ok "GPG key expires in ${days_left} days"
    fi
  else
    skip "GPG key has no expiry set (consider adding one)"
  fi
done

# 4. Master key offline (sec# not sec)
sec_live=$(gpg --list-secret-keys --with-colons 2>/dev/null | grep "^sec:[^#]" || true)
if [[ -z "$sec_live" ]]; then
  ok "Master GPG key offline (sec# confirmed)"
else
  fail "Master GPG key on disk (should show sec# -- move offline)"
fi

# 5. SSH key fingerprint (display for manual cross-machine comparison)
echo ""
echo "-- SSH --"
if [[ -f ~/.ssh/id_ed25519.pub ]]; then
  fp=$(ssh-keygen -lf ~/.ssh/id_ed25519.pub | awk '{print $2}')
  ok "SSH key present: $fp (verify unique per machine)"
else
  skip "~/.ssh/id_ed25519.pub not found"
fi

# 6. GitHub authorised keys (manual review)
echo ""
echo "-- GitHub SSH keys (review for stale entries) --"
gh api user/keys --jq '.[].title' 2>/dev/null || skip "gh CLI not authenticated"

# 7. Plaintext credential files
echo ""
echo "-- Credentials --"
for f in ~/.aws/credentials ~/.npmrc ~/.netrc; do
  if [[ -f "$f" ]]; then
    fail "Plaintext file found: $f (migrate to pass)"
  else
    ok "No plaintext: $f"
  fi
done

# 8. Pass store not in cloud path
target=$(readlink ~/.password-store 2>/dev/null || echo "")
if echo "$target" | grep -q "CloudStorage"; then
  fail "Pass store resolves to cloud path: $target"
else
  ok "Pass store not in a cloud-mounted path"
fi

# 9. Pass store git remote not a public cloud host
remote=$(pass git remote get-url origin 2>/dev/null || echo "")
if [[ -z "$remote" ]]; then
  skip "Pass store has no git remote (local-only is acceptable)"
elif echo "$remote" | grep -qE "github\.com|gitlab\.com|bitbucket\.org"; then
  fail "Pass store remote is a public cloud host: $remote"
else
  ok "Pass store remote is self-hosted: $remote"
fi

# 10. Dotfiles repository visibility
echo ""
echo "-- Dotfiles repository --"
priv=$(gh repo view rgt47/dotfiles --json isPrivate --jq .isPrivate 2>/dev/null || echo "unknown")
if [[ "$priv" == "true" ]]; then
  ok "Dotfiles repository is private"
elif [[ "$priv" == "false" ]]; then
  fail "Dotfiles repository is public"
else
  skip "Dotfiles visibility unknown (gh not authenticated or repo not found)"
fi

# 11. No sensitive dirs accidentally staged in dotfiles
echo ""
echo "-- Dotfiles git status --"
if [[ -d ~/dotfiles ]]; then
  staged=$(git -C ~/dotfiles diff --cached --name-only 2>/dev/null || echo "")
  for sensitive in .password-store .gnupg .ssh .aws; do
    if echo "$staged" | grep -q "$sensitive"; then
      fail "Sensitive path staged in dotfiles: $sensitive"
    fi
  done
  ok "No sensitive paths staged in dotfiles"
else
  skip "~/dotfiles not found"
fi

# Summary
echo ""
echo "=== Results: ${PASS} passed, ${FAIL} failed, ${SKIP} skipped ==="
[[ "$FAIL" -eq 0 ]]
