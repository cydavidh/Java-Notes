console.log('Content script executed.');

// Function to send message to background for downloading
function sendMessageForDownload(url) {
    chrome.runtime.sendMessage({ url: url });
}

// Handle images
const images = document.querySelectorAll('img.yesPopunder.image_perma_img');
images.forEach((img) => {
    const url = img.src;
    console.log(`Found image URL: ${url}`);
    sendMessageForDownload(url);
});

// Handle videos
const videos = document.querySelectorAll('video.yesPopunder.image_perma_img');
videos.forEach((video) => {
    const source = video.querySelector('source');
    if (source && source.src) {
        const videoUrl = source.src.startsWith('http') ? source.src : window.location.origin + source.src;
        console.log(`Found video URL: ${videoUrl}`);
        sendMessageForDownload(videoUrl);
    }
});

if (images.length === 0 && videos.length === 0) {
    console.log('No images or videos found.');
}
