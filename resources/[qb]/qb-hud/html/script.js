window.addEventListener('message', function(event) {
    const data = event.data;
    if (data.type === "UPDATE_HUD") {
        const hudContainer = document.getElementById('hud-container');
        const vehicleHud = document.getElementById('vehicle-hud');

        if (!data.show) {
            hudContainer.classList.add('hidden');
            return;
        }

        hudContainer.classList.remove('hidden');

        // Update player bars
        document.getElementById('health-fill').style.width = Math.min(100, Math.max(0, data.health)) + '%';
        document.getElementById('armor-fill').style.width = Math.min(100, Math.max(0, data.armor)) + '%';
        document.getElementById('stamina-fill').style.width = Math.min(100, Math.max(0, data.stamina)) + '%';

        // Vehicle HUD
        if (data.inVehicle) {
            vehicleHud.classList.remove('hidden');
            document.getElementById('speed-value').innerText = data.speed;
            document.getElementById('speed-unit').innerText = data.unit;
            document.getElementById('gear-value').innerText = data.gear === 0 ? 'R' : data.gear;
            document.getElementById('fuel-value').innerText = data.fuel + '%';
        } else {
            vehicleHud.classList.add('hidden');
        }
    }
});
