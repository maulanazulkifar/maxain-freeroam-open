let categoriesData = [];

window.addEventListener('message', function(event) {
    const data = event.data;
    if (data.type === "TOGGLE_SPAWNER") {
        const modal = document.getElementById('spawner-modal');
        if (data.show) {
            modal.classList.remove('hidden');
            categoriesData = data.categories || [];
            renderTabs();
        } else {
            modal.classList.add('hidden');
        }
    }
});

document.addEventListener('keydown', function(event) {
    if (event.key === 'Escape') {
        fetch(`https://${GetParentResourceName()}/close`, { method: 'POST' });
    }
});

function renderTabs() {
    const tabContainer = document.getElementById('category-tabs');
    tabContainer.innerHTML = '';

    categoriesData.forEach((cat, index) => {
        const btn = document.createElement('button');
        btn.className = `tab-btn ${index === 0 ? 'active' : ''}`;
        btn.innerText = cat.label;
        btn.onclick = () => {
            document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
            btn.classList.add('active');
            renderVehicles(cat);
        };
        tabContainer.appendChild(btn);
    });

    if (categoriesData.length > 0) {
        renderVehicles(categoriesData[0]);
    }
}

function renderVehicles(cat) {
    const grid = document.getElementById('vehicle-grid');
    grid.innerHTML = '';

    cat.vehicles.forEach(veh => {
        const item = document.createElement('div');
        item.className = 'veh-item';
        item.innerHTML = `
            <div class="veh-name">${veh.name}</div>
            <div class="veh-brand">${veh.brand}</div>
        `;
        item.onclick = () => {
            fetch(`https://${GetParentResourceName()}/spawnVehicle`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ model: veh.model })
            });
        };
        grid.appendChild(item);
    });
}
