let successfulDownloadTabs = new Set(); // Store tab IDs where downloads were successful

chrome.runtime.onMessage.addListener(function (request, sender, sendResponse) {
    if (request.action === "downloadImages") {
        chrome.tabs.query({ currentWindow: true }, function (tabs) {
            console.log(`Found ${tabs.length} tabs in the current window.`);
            tabs.forEach(function (tab) {
                console.log(`Attempting to inject content script into tab ${tab.id} with URL ${tab.url}`);
                chrome.scripting.executeScript({
                    target: { tabId: tab.id },
                    files: ['contentScript.js']
                }).then(() => {
                    console.log(`Successfully injected script into tab ${tab.id}`);
                }).catch(err => {
                    console.error(`Failed to inject script into tab ${tab.id}: ${err.message}`);
                });
            });
        });
    } else if (request.url && sender.tab) {
        chrome.downloads.download({
            url: request.url
        }, () => {
            console.log(`Downloading image: ${request.url}`);
            successfulDownloadTabs.add(sender.tab.id); // Add tab ID to the set when download is initiated
        });
    } else if (request.action === "closeDownloadedTabs") {
        successfulDownloadTabs.forEach(tabId => {
            chrome.tabs.remove(tabId, () => {
                console.log(`Closed tab ID: ${tabId}`);
            });
        });
        successfulDownloadTabs.clear(); // Clear the set after closing the tabs
    }
});
