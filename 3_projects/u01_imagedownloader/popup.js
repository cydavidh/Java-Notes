document.getElementById('download').addEventListener('click', () => {
    chrome.runtime.sendMessage({ action: "downloadImages" });
});

document.getElementById('closeTabs').addEventListener('click', () => {
    chrome.runtime.sendMessage({ action: "closeDownloadedTabs" });
});
