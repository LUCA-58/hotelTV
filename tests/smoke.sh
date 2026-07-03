#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

required_files=(
	"public/index.html"
	"public/styles.css"
	"public/app.js"
	"public/config.js"
	"scripts/run-local.sh"
)

for f in "${required_files[@]}"; do
	if [[ ! -f "$f" ]]; then
		echo "[smoke] missing file: $f"
		exit 1
	fi
done

grep -q "In-Room Concierge" public/index.html
grep -q "renderGreeting" public/app.js
grep -q "window.HOTEL_CONFIG" public/config.js

echo "[smoke] all checks passed"
