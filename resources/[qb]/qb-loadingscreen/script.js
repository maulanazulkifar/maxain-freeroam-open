const tips = [
    "Freeroam Tip: Press F1 or M to open vehicle options and customization menus.",
    "Drift Tip: Handbrake + clutch kick for smooth drift entry!",
    "Customize your character anytime with the illenium-appearance menu.",
    "Spawn any super, sports, or drift car instantly via the vehicle spawner!"
];

let tipIndex = 0;

setInterval(() => {
    tipIndex = (tipIndex + 1) % tips.length;
    const tipText = document.getElementById('tip-text');
    if (tipText) {
        tipText.innerText = tips[tipIndex];
    }
}, 5000);

let count = 0;
let thisCount = 0;

const handlers = {
    startInitFunctionOrder(data) {
        count = data.count;
    },
    initFunctionInvoking(data) {
        document.getElementById('loading-status').innerText = `Loading resources... (${data.idx}/${count})`;
        const percentage = Math.floor((data.idx / count) * 100);
        document.getElementById('progress-bar').style.width = percentage + '%';
        document.getElementById('progress-percent').innerText = percentage + '%';
    },
    startDataFileEntries(data) {
        count = data.count;
    },
    performMapLoadFunction(data) {
        thisCount++;
        document.getElementById('loading-status').innerText = `Map loading... (${thisCount}/${count})`;
        const percentage = Math.floor((thisCount / count) * 100);
        document.getElementById('progress-bar').style.width = percentage + '%';
        document.getElementById('progress-percent').innerText = percentage + '%';
    }
};

window.addEventListener('message', function(e) {
    if (handlers[e.data.eventName]) {
        handlers[e.data.eventName](e.data);
    }
});
