#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$REPO_ROOT"

if [[ ! -x tests/smoke.sh ]]; then
	echo "[phase4] error: tests/smoke.sh is missing or not executable"
	echo "[phase4] run ./apply-hoteltv-phase3.sh first"
	exit 1
fi

./tests/smoke.sh

echo "[phase4] verification complete"
echo "[phase4] current git status:"
git status --short
