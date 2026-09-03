let vehiclesData = [];
let categoriesData = [];
let propsData = [];
let propCategoriesData = [];

let activeMode = 'vehicles'; -- 'vehicles' or 'props'
let activeCategory = 'all';
let searchQuery = '';
let selectedVehicleForModal = null;
let is3DPreviewActive = false;

let selectedPrimaryColor = 0;
let selectedSecondaryColor = 0;

const COLOR_PRESETS = [
    { id: 0, hex: '#0d0d0d', name: 'Black' },
    { id: 111, hex: '#f0f0f0', name: 'White' },
    { id: 27, hex: '#c00c0c', name: 'Red' },
    { id: 64, hex: '#0055ff', name: 'Blue' },
    { id: 55, hex: '#00cc44', name: 'Lime Green' },
    { id: 88, hex: '#ffaa00', name: 'Yellow' },
    { id: 38, hex: '#ff5500', name: 'Orange' },
    { id: 137, hex: '#ec4899', name: 'Pink' },
    { id: 142, hex: '#8b5cf6', name: 'Purple' },
    { id: 120, hex: '#d4af37', name: 'Gold' }
];

-- DOM Elements
const spawnerContainer = document.getElementById('spawner-container');
const categoryListEl = document.getElementById('category-list');
const vehicleGridEl = document.getElementById('vehicle-grid');
const searchInput = document.getElementById('search-input');
const clearSearchBtn = document.getElementById('clear-search-btn');
const activeCategoryTitle = document.getElementById('active-category-title');
const showingCountEl = document.getElementById('showing-count');
const totalVehiclesCountEl = document.getElementById('total-vehicles-count');
const noResultsEl = document.getElementById('no-results');
const closeBtn = document.getElementById('close-btn');
const stop3DBtn = document.getElementById('stop-3d-btn');

-- Mode Tab Elements
const modeVehiclesBtn = document.getElementById('mode-vehicles-btn');
const modePropsBtn = document.getElementById('mode-props-btn');
const vehicleControls = document.getElementById('vehicle-controls');
const propControls = document.getElementById('prop-controls');
const deleteLastPropBtn = document.getElementById('delete-last-prop-btn');
const clearPropsBtn = document.getElementById('clear-props-btn');

-- Modal Elements
const modalOverlay = document.getElementById('modal-overlay');
const closeModalBtn = document.getElementById('close-modal-btn');
const modalVehImg = document.getElementById('modal-veh-img');
const modalVehBrand = document.getElementById('modal-veh-brand');
const modalVehName = document.getElementById('modal-veh-name');
const modalVehClass = document.getElementById('modal-veh-class');
const primaryColorsEl = document.getElementById('primary-colors');
const secondaryColorsEl = document.getElementById('secondary-colors');
const confirmSpawnBtn = document.getElementById('confirm-spawn-btn');
const trigger3DPreviewBtn = document.getElementById('trigger-3d-preview-btn');
const modalImagePreviewClick = document.getElementById('modal-image-preview-click');

-- Lightbox Elements
const imageLightbox = document.getElementById('image-lightbox');
const lightboxImg = document.getElementById('lightbox-img');
const lightboxTitle = document.getElementById('lightbox-title');
const closeLightboxBtn = document.getElementById('close-lightbox-btn');

-- Event Listeners
window.addEventListener('message', function (event) {
    const item = event.data;
    if (item.action === 'openMenu') {
        vehiclesData = item.vehicles || [];
        categoriesData = item.categories || [];
        propsData = item.props || [];
        propCategoriesData = item.propCategories || [];

        activeMode = item.mode || 'vehicles';
        switchMode(activeMode);
        spawnerContainer.classList.remove('hidden');
    } else if (item.action === 'closeMenu') {
        closeMenu();
    }
});

-- Mode Switcher Logic
modeVehiclesBtn.addEventListener('click', () => switchMode('vehicles'));
modePropsBtn.addEventListener('click', () => switchMode('props'));

function switchMode(mode) {
    activeMode = mode;
    stop3DPreview();

    if (activeMode === 'vehicles') {
        modeVehiclesBtn.classList.add('active');
        modePropsBtn.classList.remove('active');
        vehicleControls.classList.remove('hidden');
        propControls.classList.add('hidden');
        activeCategory = 'all';
        activeCategoryTitle.textContent = 'ALL VEHICLES';
        totalVehiclesCountEl.textContent = vehiclesData.length;
    } else {
        modePropsBtn.classList.add('active');
        modeVehiclesBtn.classList.remove('active');
        vehicleControls.classList.add('hidden');
        propControls.classList.remove('hidden');
        activeCategory = 'all_props';
        activeCategoryTitle.textContent = 'ALL OBJECTS & PROPS';
        totalVehiclesCountEl.textContent = propsData.length;
    }

    renderCategories();
    renderGrid();
}

-- Close Menu
function closeMenu() {
    stop3DPreview();
    spawnerContainer.classList.add('hidden');
    modalOverlay.classList.add('hidden');
    imageLightbox.classList.add('hidden');
    fetch(`https://${GetParentResourceName()}/close`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json; charset=UTF-8' },
        body: JSON.stringify({})
    });
}

closeBtn.addEventListener('click', closeMenu);
closeModalBtn.addEventListener('click', () => modalOverlay.classList.add('hidden'));
closeLightboxBtn.addEventListener('click', () => imageLightbox.classList.add('hidden'));
stop3DBtn.addEventListener('click', stop3DPreview);

window.addEventListener('keydown', function (e) {
    if (e.key === 'Escape') {
        if (!imageLightbox.classList.contains('hidden')) {
            imageLightbox.classList.add('hidden');
        } else if (!modalOverlay.classList.contains('hidden')) {
            modalOverlay.classList.add('hidden');
        } else if (is3DPreviewActive) {
            stop3DPreview();
        } else if (!spawnerContainer.classList.contains('hidden')) {
            closeMenu();
        }
    }
});

-- Search Input Handling
searchInput.addEventListener('input', (e) => {
    searchQuery = e.target.value.toLowerCase().trim();
    clearSearchBtn.classList.toggle('hidden', searchQuery === '');
    renderGrid();
});

clearSearchBtn.addEventListener('click', () => {
    searchInput.value = '';
    searchQuery = '';
    clearSearchBtn.classList.add('hidden');
    renderGrid();
});

-- Render Categories Sidebar
function renderCategories() {
    categoryListEl.innerHTML = '';
    const currentCats = activeMode === 'vehicles' ? categoriesData : propCategoriesData;

    currentCats.forEach(cat => {
        const li = document.createElement('li');
        li.className = `category-item ${cat.id === activeCategory ? 'active' : ''}`;
        li.innerHTML = `<i class="${cat.icon || 'fas fa-cube'}"></i> <span>${cat.label}</span>`;
        li.addEventListener('click', () => {
            document.querySelectorAll('.category-item').forEach(el => el.classList.remove('active'));
            li.classList.add('active');
            activeCategory = cat.id;
            activeCategoryTitle.textContent = cat.label.toUpperCase();
            renderGrid();
        });
        categoryListEl.appendChild(li);
    });
}

-- Main Grid Renderer (Vehicles or Props)
function renderGrid() {
    if (activeMode === 'vehicles') {
        renderVehicles();
    } else {
        renderProps();
    }
}

-- Render Vehicle Cards
function renderVehicles() {
    vehicleGridEl.innerHTML = '';

    const filtered = vehiclesData.filter(veh => {
        const matchesCategory = activeCategory === 'all' || veh.category === activeCategory;
        const matchesSearch = searchQuery === '' ||
            veh.name.toLowerCase().includes(searchQuery) ||
            veh.model.toLowerCase().includes(searchQuery) ||
            (veh.brand && veh.brand.toLowerCase().includes(searchQuery));
        return matchesCategory && matchesSearch;
    });

    showingCountEl.textContent = `Showing ${filtered.length} items`;
    noResultsEl.classList.toggle('hidden', filtered.length > 0);

    filtered.forEach(veh => {
        const card = document.createElement('div');
        card.className = 'veh-card';

        const fallbackImg = `https://via.placeholder.com/400x250/141b2c/00f0ff?text=${encodeURIComponent(veh.name)}`;
        const imgUrl = veh.image || fallbackImg;

        card.innerHTML = `
            <div class="card-img-wrapper" title="Click to view image">
                <img src="${imgUrl}" alt="${veh.name}" onerror="this.onerror=null; this.src='${fallbackImg}';">
                <div class="card-img-hover-overlay"><i class="fas fa-search-plus"></i> View Image</div>
                <span class="class-badge">${veh.class || 'Vehicle'}</span>
            </div>
            <div class="card-body">
                <div>
                    <span class="brand-name">${veh.brand || 'GTA V'}</span>
                    <h3 class="veh-name">${veh.name}</h3>
                </div>
                <div class="stats-bars">
                    <div class="stat-row">
                        <label>Speed</label>
                        <div class="bar-bg">
                            <div class="bar-fill" style="width: ${veh.speed || 80}%"></div>
                        </div>
                    </div>
                    <div class="stat-row">
                        <label>Accel</label>
                        <div class="bar-bg">
                            <div class="bar-fill" style="width: ${veh.accel || 80}%"></div>
                        </div>
                    </div>
                </div>
                <div class="card-actions">
                    <button class="btn-spawn" data-model="${veh.model}">
                        <i class="fas fa-play"></i> SPAWN
                    </button>
                    <button class="btn-3d-cam" title="3D In-Game Camera Preview">
                        <i class="fas fa-cube"></i>
                    </button>
                    <button class="btn-color" title="Custom Colors">
                        <i class="fas fa-palette"></i>
                    </button>
                </div>
            </div>
        `;

        card.querySelector('.card-img-wrapper').addEventListener('click', () => openLightbox(imgUrl, veh.name));

        card.querySelector('.btn-spawn').addEventListener('click', (e) => {
            e.stopPropagation();
            spawnVehicle(veh.model, veh.name, null, null);
        });

        card.querySelector('.btn-3d-cam').addEventListener('click', (e) => {
            e.stopPropagation();
            start3DPreview(veh.model, selectedPrimaryColor, selectedSecondaryColor);
        });

        card.querySelector('.btn-color').addEventListener('click', (e) => {
            e.stopPropagation();
            openColorModal(veh);
        });

        vehicleGridEl.appendChild(card);
    });
}

-- Render Prop Cards
function renderProps() {
    vehicleGridEl.innerHTML = '';

    const filtered = propsData.filter(prop => {
        const matchesCategory = activeCategory === 'all_props' || prop.category === activeCategory;
        const matchesSearch = searchQuery === '' ||
            prop.name.toLowerCase().includes(searchQuery) ||
            prop.model.toLowerCase().includes(searchQuery);
        return matchesCategory && matchesSearch;
    });

    showingCountEl.textContent = `Showing ${filtered.length} props`;
    noResultsEl.classList.toggle('hidden', filtered.length > 0);

    filtered.forEach(prop => {
        const card = document.createElement('div');
        card.className = 'veh-card';

        const fallbackImg = `https://via.placeholder.com/400x250/141b2c/8b5cf6?text=${encodeURIComponent(prop.name)}`;
        const imgUrl = prop.image && prop.image !== '' ? prop.image : fallbackImg;

        card.innerHTML = `
            <div class="card-img-wrapper">
                <img src="${imgUrl}" alt="${prop.name}" onerror="this.onerror=null; this.src='${fallbackImg}';">
                <span class="class-badge" style="color: var(--accent-purple);">${prop.type || 'Object'}</span>
            </div>
            <div class="card-body">
                <div>
                    <span class="brand-name">${prop.model}</span>
                    <h3 class="veh-name">${prop.name}</h3>
                </div>
                <div class="card-actions" style="margin-top: 24px;">
                    <button class="btn-spawn btn-spawn-prop" style="background: linear-gradient(135deg, var(--accent-purple), #6d28d9);">
                        <i class="fas fa-cube"></i> SPAWN PROP
                    </button>
                </div>
            </div>
        `;

        card.querySelector('.btn-spawn-prop').addEventListener('click', (e) => {
            e.stopPropagation();
            spawnProp(prop.model, prop.name);
        });

        vehicleGridEl.appendChild(card);
    });
}

-- Lightbox Handler
function openLightbox(imgUrl, title) {
    lightboxImg.src = imgUrl;
    lightboxTitle.textContent = title;
    imageLightbox.classList.remove('hidden');
}

-- 3D Camera Preview
function start3DPreview(model, primaryColor, secondaryColor) {
    is3DPreviewActive = true;
    stop3DBtn.classList.remove('hidden');
    fetch(`https://${GetParentResourceName()}/start3DPreview`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json; charset=UTF-8' },
        body: JSON.stringify({
            model: model,
            primaryColor: primaryColor,
            secondaryColor: secondaryColor
        })
    });
}

function stop3DPreview() {
    if (is3DPreviewActive) {
        is3DPreviewActive = false;
        stop3DBtn.classList.add('hidden');
        fetch(`https://${GetParentResourceName()}/stop3DPreview`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json; charset=UTF-8' },
            body: JSON.stringify({})
        });
    }
}

trigger3DPreviewBtn.addEventListener('click', () => {
    if (selectedVehicleForModal) {
        start3DPreview(
            selectedVehicleForModal.model,
            selectedPrimaryColor,
            selectedSecondaryColor
        );
    }
});

-- Vehicle Spawn API
function spawnVehicle(model, name, primaryColor, secondaryColor) {
    fetch(`https://${GetParentResourceName()}/spawnVehicle`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json; charset=UTF-8' },
        body: JSON.stringify({
            model: model,
            name: name,
            primaryColor: primaryColor,
            secondaryColor: secondaryColor
        })
    });
}

-- Prop Spawn API
function spawnProp(model, name) {
    fetch(`https://${GetParentResourceName()}/spawnProp`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json; charset=UTF-8' },
        body: JSON.stringify({
            model: model,
            name: name
        })
    });
}

-- Clear Props Controls
deleteLastPropBtn.addEventListener('click', () => {
    fetch(`https://${GetParentResourceName()}/deleteLastProp`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json; charset=UTF-8' },
        body: JSON.stringify({})
    });
});

clearPropsBtn.addEventListener('click', () => {
    fetch(`https://${GetParentResourceName()}/clearAllProps`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json; charset=UTF-8' },
        body: JSON.stringify({})
    });
});

-- Color Picker Modal Setup
function openColorModal(veh) {
    selectedVehicleForModal = veh;
    modalVehImg.src = veh.image || `https://via.placeholder.com/400x250/141b2c/00f0ff?text=${encodeURIComponent(veh.name)}`;
    modalVehBrand.textContent = veh.brand || 'GTA V';
    modalVehName.textContent = veh.name;
    modalVehClass.textContent = veh.class || 'VEHICLE';

    renderColorOptions(primaryColorsEl, 'primary');
    renderColorOptions(secondaryColorsEl, 'secondary');

    modalOverlay.classList.remove('hidden');
}

modalImagePreviewClick.addEventListener('click', () => {
    if (selectedVehicleForModal) {
        openLightbox(selectedVehicleForModal.image, selectedVehicleForModal.name);
    }
});

function renderColorOptions(container, type) {
    container.innerHTML = '';
    COLOR_PRESETS.forEach(color => {
        const swatch = document.createElement('div');
        swatch.className = `color-swatch ${(type === 'primary' && color.id === selectedPrimaryColor) || (type === 'secondary' && color.id === selectedSecondaryColor) ? 'active' : ''}`;
        swatch.style.backgroundColor = color.hex;
        swatch.title = color.name;
        swatch.addEventListener('click', () => {
            container.querySelectorAll('.color-swatch').forEach(s => s.classList.remove('active'));
            swatch.classList.add('active');
            if (type === 'primary') selectedPrimaryColor = color.id;
            else selectedSecondaryColor = color.id;

            if (is3DPreviewActive && selectedVehicleForModal) {
                start3DPreview(selectedVehicleForModal.model, selectedPrimaryColor, selectedSecondaryColor);
            }
        });
        container.appendChild(swatch);
    });
}

confirmSpawnBtn.addEventListener('click', () => {
    if (selectedVehicleForModal) {
        spawnVehicle(
            selectedVehicleForModal.model,
            selectedVehicleForModal.name,
            selectedPrimaryColor,
            selectedSecondaryColor
        );
        modalOverlay.classList.add('hidden');
    }
});
