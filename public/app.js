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
