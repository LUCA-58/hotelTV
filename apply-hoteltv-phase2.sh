#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$REPO_ROOT"

mkdir -p public

HOTEL_NAME="${HOTEL_NAME:-hotelTV}"
WIFI_SSID="${WIFI_SSID:-HOTEL-GUEST}"
WIFI_PASSWORD="${WIFI_PASSWORD:-12345678}"
FRONT_DESK_PHONE="${FRONT_DESK_PHONE:-0}"
ROOM_SERVICE_PHONE="${ROOM_SERVICE_PHONE:-9}"
WEATHER_LAT="${WEATHER_LAT:-25.0330}"
WEATHER_LON="${WEATHER_LON:-121.5654}"
WEATHER_CITY="${WEATHER_CITY:-Taipei}"

escape_js() {
	local value="$1"
	value="${value//\\/\\\\}"
	value="${value//\'/\\\'}"
	value="${value//$'\n'/ }"
	printf "%s" "$value"
}

HOTEL_NAME_ESCAPED="$(escape_js "$HOTEL_NAME")"
WIFI_SSID_ESCAPED="$(escape_js "$WIFI_SSID")"
WIFI_PASSWORD_ESCAPED="$(escape_js "$WIFI_PASSWORD")"
FRONT_DESK_PHONE_ESCAPED="$(escape_js "$FRONT_DESK_PHONE")"
ROOM_SERVICE_PHONE_ESCAPED="$(escape_js "$ROOM_SERVICE_PHONE")"
WEATHER_CITY_ESCAPED="$(escape_js "$WEATHER_CITY")"

cat > public/index.html <<'EOF'
<!doctype html>
<html lang="en">
	<head>
		<meta charset="utf-8" />
		<meta name="viewport" content="width=device-width, initial-scale=1" />
		<title>hotelTV Home</title>
		<link rel="stylesheet" href="./styles.css" />
	</head>
	<body>
		<div class="bg-glow bg-glow-a"></div>
		<div class="bg-glow bg-glow-b"></div>
		<main class="tv-shell">
			<header class="hero">
				<div>
					<p class="badge">In-Room Concierge</p>
					<h1 id="hotel-name">Welcome</h1>
					<p id="greeting" class="greeting" aria-live="polite"></p>
				</div>
				<div class="timebox">
					<p class="time-label">Local Time</p>
					<p id="clock" class="clock" aria-live="polite"></p>
				</div>
			</header>

			<section class="layout">
				<article class="panel weather-panel">
					<h2>Weather</h2>
					<p id="weather-city" class="muted"></p>
					<p id="weather-now" class="weather-now">Loading...</p>
				</article>

				<article class="panel wifi-panel">
					<h2>Wi-Fi</h2>
					<p id="wifi-ssid"></p>
					<p id="wifi-password"></p>
				</article>

				<article class="card">
					<h2>Channel Guide</h2>
					<ul id="channels" class="list"></ul>
				</article>

				<article class="card">
					<h2>Announcements</h2>
					<ul id="announcements" class="list"></ul>
				</article>

				<article class="panel contact-panel">
					<h2>Quick Contact</h2>
					<p id="front-desk"></p>
					<p id="room-service"></p>
				</article>
			</section>
		</main>

		<script src="./config.js"></script>
		<script src="./app.js"></script>
	</body>
</html>
EOF

cat > public/config.js <<EOF
window.HOTEL_CONFIG = {
  hotelName: '${HOTEL_NAME_ESCAPED}',
  wifiSsid: '${WIFI_SSID_ESCAPED}',
  wifiPassword: '${WIFI_PASSWORD_ESCAPED}',
  frontDeskPhone: '${FRONT_DESK_PHONE_ESCAPED}',
  roomServicePhone: '${ROOM_SERVICE_PHONE_ESCAPED}',
  weather: {
    city: '${WEATHER_CITY_ESCAPED}',
    lat: ${WEATHER_LAT},
    lon: ${WEATHER_LON}
  }
};
EOF

cat > public/styles.css <<'EOF'
@import url("https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;600;700&family=Noto+Sans:wght@400;500;700&display=swap");

:root {
	--bg-base: #081221;
	--bg-accent: #0e223d;
	--mint: #52e5b2;
	--aqua: #4dd7ff;
	--peach: #ffb66d;
	--card: #0b1b30cc;
	--line: #2a4966;
	--text: #f2fbff;
	--muted: #acd3e8;
}

* {
	box-sizing: border-box;
}

body {
	margin: 0;
	min-height: 100vh;
	font-family: "Noto Sans", "Segoe UI", sans-serif;
	color: var(--text);
	background: radial-gradient(circle at 12% 8%, #173f6d 0%, #0c1c32 28%, transparent 55%),
		linear-gradient(135deg, var(--bg-base), var(--bg-accent));
	overflow-x: hidden;
}


.bg-glow {
	position: fixed;
	width: 38vmax;
	height: 38vmax;
	filter: blur(40px);
	opacity: 0.25;
	pointer-events: none;
	z-index: 0;
}

.bg-glow-a {
	background: #24ffc8;
	top: -12vmax;
	left: -10vmax;
}

.bg-glow-b {
	background: #3b93ff;
	right: -12vmax;
	bottom: -12vmax;
}

.tv-shell {
	position: relative;
	z-index: 1;
	max-width: 1080px;
	margin: 0 auto;
	padding: 1.2rem 1rem 2rem;
}

.hero {
	display: flex;
	justify-content: space-between;
	gap: 1rem;
	align-items: flex-start;
	margin-bottom: 1rem;
	padding: 1rem;
	background: linear-gradient(135deg, #0d2846cc, #0a1e34cc);
	border: 1px solid var(--line);
	border-radius: 20px;
	backdrop-filter: blur(6px);
}

.badge {
	display: inline-block;
	margin: 0;
	padding: 0.3rem 0.65rem;
	border-radius: 999px;
	background: #183b5f;
	color: var(--aqua);
	font-size: 0.75rem;
	text-transform: uppercase;
	letter-spacing: 0.08em;
}

#hotel-name {
	font-family: "Space Grotesk", "Noto Sans", sans-serif;
	margin: 0;
	font-size: clamp(1.6rem, 2.6vw, 2.4rem);
}

.greeting {
	margin: 0.4rem 0 0;
	font-size: 1.05rem;
	color: var(--muted);
}

.timebox {
	text-align: right;
	min-width: 220px;
}

.time-label {
	margin: 0;
	font-size: 0.8rem;
	letter-spacing: 0.08em;
	text-transform: uppercase;
	color: var(--muted);
}

.clock {
	margin: 0.2rem 0 0;
	font-family: "Space Grotesk", "Noto Sans", sans-serif;
	font-size: 1.2rem;
	font-weight: 600;
}

.layout {
	display: grid;
	grid-template-columns: repeat(12, minmax(0, 1fr));
	gap: 1rem;
}


.panel,
.card {
	background: var(--card);
	border: 1px solid var(--line);
	border-radius: 16px;
	padding: 1rem;
	box-shadow: 0 8px 30px #03122466;
	min-height: 180px;
}

.weather-panel {
	grid-column: span 4;
}

.wifi-panel {
	grid-column: span 4;
}

.contact-panel {
	grid-column: span 4;
}

.card {
	grid-column: span 6;
}

.panel h2,
.card h2 {
	margin-top: 0;
	margin-bottom: 0.65rem;
	font-family: "Space Grotesk", "Noto Sans", sans-serif;
	color: var(--mint);
}


.panel p,
.card p {
	margin: 0.2rem 0;
}

.muted {
	color: var(--muted);
}

.weather-now {
	font-size: 1.4rem;
	font-weight: 700;
	margin-top: 0.8rem;
	color: var(--peach);
}

.list {
	margin: 0.4rem 0 0;
	padding-left: 1.1rem;
	display: grid;
	gap: 0.35rem;
}

@media (max-width: 900px) {
	.hero {
		flex-direction: column;
	}

	.timebox {
		text-align: left;
		min-width: 0;
	}

	.weather-panel,
	.wifi-panel,
	.contact-panel,
	.card {
		grid-column: span 12;
	}
}
EOF

cat > public/app.js <<'EOF'
const config = window.HOTEL_CONFIG || {
	hotelName: "hotelTV",
	wifiSsid: "HOTEL-GUEST",
	wifiPassword: "12345678",
	frontDeskPhone: "0",
	roomServicePhone: "9",
	weather: {
		city: "Taipei",
		lat: 25.033,
		lon: 121.5654,
	},
};

const channels = [
	"CH 1  Hotel Info",
	"CH 8  International News",
	"CH 12 Nature Documentary",
	"CH 18 Family Movies",
	"CH 26 Sports Highlights",
];

const announcements = [
	"Breakfast: 06:30-10:00 at 2F Restaurant",
	"Pool closed for maintenance from 14:00 to 16:00",
	"Airport shuttle departs every hour from the main entrance",
	"Quiet hours start at 22:00",
];

function renderClock() {
	const clock = document.getElementById("clock");
	if (!clock) return;

	const now = new Date();
	clock.textContent = now.toLocaleString("en-US", {
		weekday: "short",
		year: "numeric",
		month: "short",
		day: "numeric",
		hour: "2-digit",
		minute: "2-digit",
		second: "2-digit",
	});
}

function renderGreeting() {
	const hour = new Date().getHours();
	const greeting = document.getElementById("greeting");
	const hotelName = document.getElementById("hotel-name");
	if (!greeting || !hotelName) return;

	let period = "Good evening";
	if (hour >= 5 && hour < 12) period = "Good morning";
	if (hour >= 12 && hour < 18) period = "Good afternoon";

	hotelName.textContent = config.hotelName;
	greeting.textContent = `${period}. Enjoy your stay at ${config.hotelName}.`;
}

function renderStaticInfo() {
	const city = document.getElementById("weather-city");
	const ssid = document.getElementById("wifi-ssid");
	const password = document.getElementById("wifi-password");
	const frontDesk = document.getElementById("front-desk");
	const roomService = document.getElementById("room-service");

	if (city) city.textContent = config.weather.city;
	if (ssid) ssid.textContent = `SSID: ${config.wifiSsid}`;
	if (password) password.textContent = `Password: ${config.wifiPassword}`;
	if (frontDesk) frontDesk.textContent = `Front Desk: ${config.frontDeskPhone}`;
	if (roomService) roomService.textContent = `Room Service: ${config.roomServicePhone}`;
}

function renderList(id, items) {
	const target = document.getElementById(id);
	if (!target) return;
	target.innerHTML = items.map((item) => `<li>${item}</li>`).join("");
}

function weatherCodeToText(code) {
	const map = {
		0: "Clear sky",
		1: "Mainly clear",
		2: "Partly cloudy",
		3: "Overcast",
		45: "Fog",
		51: "Light drizzle",
		61: "Light rain",
		63: "Moderate rain",
		71: "Light snow",
		80: "Rain showers",
		95: "Thunderstorm",
	};
	return map[code] || "Unknown";
}

async function renderWeather() {
	const weatherNow = document.getElementById("weather-now");
	if (!weatherNow) return;

	const { lat, lon } = config.weather;
	const url = `https://api.open-meteo.com/v1/forecast?latitude=${lat}&longitude=${lon}&current_weather=true`;

	try {
		const response = await fetch(url);
		if (!response.ok) throw new Error("weather request failed");

		const data = await response.json();
		const current = data.current_weather;
		if (!current) throw new Error("missing weather payload");

		const text = weatherCodeToText(current.weathercode);
		weatherNow.textContent = `${Math.round(current.temperature)} C, ${text}`;
	} catch (_error) {
		weatherNow.textContent = "Weather unavailable right now";
	}
}

function init() {
	renderGreeting();
	renderStaticInfo();
	renderList("channels", channels);
	renderList("announcements", announcements);
	renderClock();
	renderWeather();
	setInterval(renderClock, 1000);
}

init();
EOF

echo "[phase2] upgraded hotelTV homepage scaffolded in public/"
