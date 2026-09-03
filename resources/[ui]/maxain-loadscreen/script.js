// Default YouTube Video ID for Loading Screen
const YOUTUBE_VIDEO_ID = 'YWHT0m58s_U';

let player;
let isMuted = true;

// YouTube IFrame API Ready Callback
function onYouTubeIframeAPIReady() {
    player = new YT.Player('youtube-player', {
        videoId: YOUTUBE_VIDEO_ID,
        playerVars: {
            'autoplay': 1,
            'controls': 0,
            'showinfo': 0,
            'modestbranding': 1,
            'loop': 1,
            'playlist': YOUTUBE_VIDEO_ID,
            'fs': 0,
            'cc_load_policy': 0,
            'iv_load_policy': 3,
            'autohide': 1,
            'enablejsapi': 1,
            'mute': 1
        },
        events: {
            'onReady': onPlayerReady
        }
    });
}

function onPlayerReady(event) {
    event.target.playVideo();
    event.target.mute();
}

// Audio Toggle Button
document.addEventListener('DOMContentLoaded', () => {
    const audioBtn = document.getElementById('audio-toggle');
    const audioIcon = document.getElementById('audio-icon');
    const audioText = document.getElementById('audio-text');

    if (audioBtn) {
        audioBtn.addEventListener('click', () => {
            if (!player || typeof player.isMuted !== 'function') return;

            if (player.isMuted()) {
                player.unMute();
                player.setVolume(50);
                audioIcon.className = 'fa-solid fa-volume-high';
                audioText.innerText = 'Audio Playing';
                audioBtn.style.borderColor = '#06b6d4';
            } else {
                player.mute();
                audioIcon.className = 'fa-solid fa-volume-xmark';
                audioText.innerText = 'Audio Muted';
                audioBtn.style.borderColor = 'rgba(255, 255, 255, 0.12)';
            }
        });
    }
});

// FiveM Loading Progress Handlers
let totalCount = 1;
let currentCount = 0;

const progressFill = document.getElementById('progress-fill');
const progressPercent = document.getElementById('loading-percentage');
const statusText = document.getElementById('loading-status');
const logText = document.getElementById('loading-log');

const updateProgress = (percentage) => {
    const clamped = Math.min(100, Math.max(0, Math.round(percentage)));
    if (progressFill) progressFill.style.width = `${clamped}%`;
    if (progressPercent) progressPercent.innerText = `${clamped}%`;
};

const handlers = {
    startInitFunctionOrder(data) {
        totalCount = data.count || 1;
        if (statusText) statusText.innerText = 'Memuat sistem server...';
    },

    initFunctionInvoking(data) {
        currentCount = data.idx || 0;
        const percent = (currentCount / totalCount) * 60;
        updateProgress(percent);
    },

    startDataFileEntries(data) {
        totalCount = data.count || 1;
        if (statusText) statusText.innerText = 'Memuat peta & resource...';
    },

    performMapLoadFunction(data) {
        currentCount = (data.idx || currentCount + 1);
        const percent = 60 + ((currentCount / totalCount) * 40);
        updateProgress(percent);
    },

    onLogLine(data) {
        if (logText && data.message) {
            logText.innerText = data.message;
        }
    }
};

window.addEventListener('message', (e) => {
    if (e.data && e.data.eventName && handlers[e.data.eventName]) {
        handlers[e.data.eventName](e.data);
    }
});
