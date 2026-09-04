// MAXAIN ADMIN PANEL — Minimalist B&W Client Logic

// Configuration State
const config = {
    hostUrl: localStorage.getItem('maxain_host_url') || 'http://127.0.0.1:30120',
    apiKey: localStorage.getItem('maxain_api_key') || 'maxain_secret_api_key_2026'
};

let currentPeds = ["mp_m_freemode_01", "mp_f_freemode_01"];
let currentVehicles = [];

// DOM Elements
const statusIndicator = document.getElementById('statusIndicator');
const statusText = document.getElementById('statusText');
const playerCount = document.getElementById('playerCount');
const serverName = document.getElementById('serverName');
const gameBuild = document.getElementById('gameBuild');
const serverUptime = document.getElementById('serverUptime');
const apiStatus = document.getElementById('apiStatus');

const pedsTableBody = document.getElementById('pedsTableBody');
const vehTableBody = document.getElementById('vehTableBody');
const consoleOutput = document.getElementById('consoleOutput');
const consoleForm = document.getElementById('consoleForm');
const consoleInput = document.getElementById('consoleInput');

// Settings Modal
const settingsModal = document.getElementById('settingsModal');
const btnSettingsModal = document.getElementById('btnSettingsModal');
const btnCloseModal = document.getElementById('btnCloseModal');
const btnSaveSettings = document.getElementById('btnSaveSettings');
const cfgHostUrl = document.getElementById('cfgHostUrl');
const cfgApiKey = document.getElementById('cfgApiKey');

// Initialize Modal Inputs
cfgHostUrl.value = config.hostUrl;
cfgApiKey.value = config.apiKey;

btnSettingsModal.addEventListener('click', () => settingsModal.classList.add('active'));
btnCloseModal.addEventListener('click', () => settingsModal.classList.remove('active'));

btnSaveSettings.addEventListener('click', () => {
    config.hostUrl = cfgHostUrl.value.trim();
    config.apiKey = cfgApiKey.value.trim();
    localStorage.setItem('maxain_host_url', config.hostUrl);
    localStorage.setItem('maxain_api_key', config.apiKey);
    settingsModal.classList.remove('active');
    logConsole('[SYSTEM] Settings saved. Reconnecting...');
    fetchServerStatus();
});

// Tab Navigation
const navItems = document.querySelectorAll('.nav-item');
const tabContents = document.querySelectorAll('.tab-content');

navItems.forEach(item => {
    item.addEventListener('click', () => {
        const targetTab = item.getAttribute('data-tab');
        navItems.forEach(n => n.classList.remove('active'));
        tabContents.forEach(t => t.classList.remove('active'));

        item.classList.add('active');
        document.getElementById(`tab-${targetTab}`).classList.add('active');
    });
});

// API Fetch Helper
async function apiRequest(endpoint, method = 'GET', data = null) {
    const url = `${config.hostUrl}${endpoint}`;
    const headers = {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${config.apiKey}`
    };

    const options = { method, headers };
    if (data) {
        options.body = JSON.stringify(data);
    }

    try {
        const res = await fetch(url, options);
        if (!res.ok) {
            const errData = await res.json().catch(() => ({}));
            throw new Error(errData.error || `HTTP ${res.status}`);
        }
        return await res.json();
    } catch (err) {
        throw err;
    }
}

// Fetch Server Status
async function fetchServerStatus() {
    try {
        const data = await apiRequest('/api/status');
        statusIndicator.classList.add('online');
        statusText.textContent = 'ONLINE';
        playerCount.textContent = `${data.playersOnline}/${data.maxClients}`;
        serverName.textContent = data.serverName || 'Maxain Studio Freeroam';
        gameBuild.textContent = data.gameBuild || '3905';
        
        const uptimeMins = Math.floor(data.uptimeSeconds / 60);
        serverUptime.textContent = `${uptimeMins}m (${data.uptimeSeconds}s)`;
        apiStatus.textContent = 'CONNECTED';
    } catch (err) {
        statusIndicator.classList.remove('online');
        statusText.textContent = 'OFFLINE';
        playerCount.textContent = '0/0';
        apiStatus.textContent = 'ERROR / DISCONNECTED';
    }
}

// Fetch Peds List
async function fetchPeds() {
    try {
        const data = await apiRequest('/api/peds');
        if (data && data.peds) {
            currentPeds = data.peds;
            renderPedsTable();
        }
    } catch (err) {
        logConsole(`[ERROR] Failed to fetch peds list: ${err.message}`);
    }
}

function renderPedsTable() {
    pedsTableBody.innerHTML = '';
    currentPeds.forEach((model, index) => {
        const tr = document.createElement('tr');
        const isFreemode = model.includes('freemode');
        tr.innerHTML = `
            <td>${index + 1}</td>
            <td><strong>${model}</strong></td>
            <td>${isFreemode ? 'Freemode Player Model' : 'Custom / NPC Ped'}</td>
            <td>
                <button class="btn btn-danger" onclick="removePed('${model}')">REMOVE</button>
            </td>
        `;
        pedsTableBody.appendChild(tr);
    });
}

// Add & Remove Ped Functions
document.getElementById('btnAddPed').addEventListener('click', () => {
    const input = document.getElementById('inputPedModel');
    const modelName = input.value.trim().toLowerCase();
    if (!modelName) return;

    if (!currentPeds.includes(modelName)) {
        currentPeds.push(modelName);
        renderPedsTable();
        input.value = '';
        logConsole(`[PED] Added model '${modelName}' locally. Click 'SYNC TO FIVEM SERVER' to apply.`);
    }
});

window.removePed = function(modelName) {
    currentPeds = currentPeds.filter(p => p !== modelName);
    renderPedsTable();
    logConsole(`[PED] Removed model '${modelName}' locally. Click 'SYNC TO FIVEM SERVER' to apply.`);
};

// Sync Peds to Server
document.getElementById('btnSyncPeds').addEventListener('click', async () => {
    try {
        logConsole('[PED] Syncing ped list to FiveM server...');
        const res = await apiRequest('/api/peds', 'POST', { peds: currentPeds });
        if (res.success) {
            logConsole('[PED] SUCCESS: Peds updated & illenium-appearance restarted!');
            alert('Peds updated successfully and illenium-appearance restarted on server!');
        }
    } catch (err) {
        logConsole(`[ERROR] Sync failed: ${err.message}`);
        alert(`Sync Failed: ${err.message}`);
    }
});

// Fetch & Render Vehicle Catalog
async function fetchVehicles() {
    try {
        const data = await apiRequest('/api/vehicles');
        if (data && data.vehicles) {
            currentVehicles = data.vehicles;
            renderVehicleTable();
        }
    } catch (err) {
        logConsole(`[ERROR] Failed to fetch vehicles: ${err.message}`);
    }
}

function renderVehicleTable() {
    vehTableBody.innerHTML = '';
    currentVehicles.forEach(veh => {
        const tr = document.createElement('tr');
        tr.innerHTML = `
            <td><code>${veh.spawnName}</code></td>
            <td><strong>${veh.label}</strong></td>
            <td>${veh.category}</td>
            <td>$${Number(veh.price).toLocaleString()}</td>
        `;
        vehTableBody.appendChild(tr);
    });
}

// Add Vehicle Handler
document.getElementById('btnAddVehicle').addEventListener('click', async () => {
    const spawnName = document.getElementById('vehSpawnName').value.trim();
    const label = document.getElementById('vehLabel').value.trim();
    const category = document.getElementById('vehCategory').value.trim() || 'General';
    const price = document.getElementById('vehPrice').value.trim() || '0';

    if (!spawnName || !label) {
        alert('Please fill in Spawn Name and Display Label');
        return;
    }

    try {
        const res = await apiRequest('/api/vehicles', 'POST', { spawnName, label, category, price });
        if (res.vehicles) {
            currentVehicles = res.vehicles;
            renderVehicleTable();
            document.getElementById('vehSpawnName').value = '';
            document.getElementById('vehLabel').value = '';
            document.getElementById('vehCategory').value = '';
            document.getElementById('vehPrice').value = '';
            logConsole(`[VEHICLE] Added vehicle '${label}' (${spawnName}) to catalog.`);
        }
    } catch (err) {
        alert(`Failed to add vehicle: ${err.message}`);
    }
});

// Remote Console Execution
window.executeQuickCommand = async function(cmd) {
    logConsole(`[RCON EXEC] > ${cmd}`);
    try {
        const res = await apiRequest('/api/rcon', 'POST', { command: cmd });
        if (res.success) {
            logConsole(`[RCON SUCCESS] Executed command: '${cmd}'`);
        }
    } catch (err) {
        logConsole(`[RCON ERROR] Execution failed: ${err.message}`);
    }
};

consoleForm.addEventListener('submit', async (e) => {
    e.preventDefault();
    const cmd = consoleInput.value.trim();
    if (!cmd) return;
    consoleInput.value = '';
    await executeQuickCommand(cmd);
});

function logConsole(msg) {
    const div = document.createElement('div');
    div.textContent = msg;
    consoleOutput.appendChild(div);
    consoleOutput.scrollTop = consoleOutput.scrollHeight;
}

// Initial Loading
fetchServerStatus();
fetchPeds();
fetchVehicles();
setInterval(fetchServerStatus, 5000);
