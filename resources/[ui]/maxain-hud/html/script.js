const hudContainer = document.getElementById('hud-container');
const speedValue = document.getElementById('speed-value');
const gearValue = document.getElementById('gear-value');
const fuelValue = document.getElementById('fuel-value');
const streetName = document.getElementById('street-name');
const driftBadge = document.getElementById('drift-badge');
const gaugeFill = document.getElementById('gauge-fill');

// Circumference of SVG circle (2 * PI * 85) ~ 534
const MAX_CIRCUMFERENCE = 534;
const MAX_SPEED = 280; // Max KM/H for full gauge arc

window.addEventListener('message', (event) => {
    const data = event.data;

    if (data.type === "updateHud") {
        if (data.show) {
            hudContainer.classList.remove('hidden');
            
            // Speed
            const speed = data.speed || 0;
            speedValue.innerText = speed;

            // Gauge fill calculation (Arc from 0 to MAX_SPEED)
            const speedRatio = Math.min(speed / MAX_SPEED, 1);
            // 75% arc coverage (approx 400 offset delta)
            const strokeOffset = MAX_CIRCUMFERENCE - (speedRatio * 380);
            gaugeFill.style.strokeDashoffset = strokeOffset;

            // Gear & Fuel
            if (gearValue) gearValue.innerText = data.gear || 'N';
            if (fuelValue) fuelValue.innerText = `${data.fuel || 100}%`;
            
            // Street Name
            if (streetName && data.street) {
                streetName.innerText = data.street.toUpperCase();
            }

            // Drift Mode Badge
            if (driftBadge) {
                if (data.drift) {
                    driftBadge.classList.remove('hidden');
                } else {
                    driftBadge.classList.add('hidden');
                }
            }
        } else {
            hudContainer.classList.add('hidden');
        }
    } else if (data.type === "updateDrift") {
        if (driftBadge) {
            if (data.drift) {
                driftBadge.classList.remove('hidden');
            } else {
                driftBadge.classList.add('hidden');
            }
        }
    }
});
