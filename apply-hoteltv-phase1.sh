#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$REPO_ROOT"

if [[ ! -d .git ]]; then
	echo "[phase1] error: this script must run in the repository root"
	exit 1
fi

mkdir -p public scripts tests

cat > .gitignore <<'EOF'
# Logs
*.log

# Node modules
node_modules/

# Build output
dist/
coverage/
EOF

cat > README.md <<'EOF'
# hotelTV

Incremental setup driven by 4 phase scripts.

## Configurable parameters

The project supports environment-variable based configuration when running phase scripts.

- `HOTEL_NAME` (default: `hotelTV`)
- `WIFI_SSID` (default: `HOTEL-GUEST`)
- `WIFI_PASSWORD` (default: `12345678`)
- `FRONT_DESK_PHONE` (default: `0`)
- `ROOM_SERVICE_PHONE` (default: `9`)
- `WEATHER_LAT` (default: `25.0330`)
- `WEATHER_LON` (default: `121.5654`)
- `WEATHER_CITY` (default: `Taipei`)

## Quick start

Run in order:

```bash
chmod +x apply-hoteltv-phase1.sh apply-hoteltv-phase2.sh apply-hoteltv-phase3.sh apply-hoteltv-phase4.sh
./apply-hoteltv-phase1.sh
./apply-hoteltv-phase2.sh
./apply-hoteltv-phase3.sh
./apply-hoteltv-phase4.sh
```

With custom hotel settings:

```bash
HOTEL_NAME="Luca Grand Hotel" \
WIFI_SSID="Luca-Guest" \
WIFI_PASSWORD="StayWithLuca" \
FRONT_DESK_PHONE="100" \
ROOM_SERVICE_PHONE="200" \
WEATHER_CITY="Shanghai" \
WEATHER_LAT="31.2304" \
WEATHER_LON="121.4737" \
./apply-hoteltv-phase2.sh
```

## Run locally

```bash
./scripts/run-local.sh
```

Then open http://localhost:8000.

## UI modules

- Live clock and contextual greeting
- Weather panel (Open-Meteo)
- Channel recommendations
- Hotel announcements
- Wi-Fi and contact quick info
EOF

echo "[phase1] repository bootstrap completed"
