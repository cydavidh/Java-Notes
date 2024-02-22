chrome.runtime.onInstalled.addListener(() => {
    // Initialize the list of blocked sites on installation
    chrome.storage.local.set({
        blockedSites: ["9gag.com", "smutty.com", "xvideos.com", "disp.cc", "reddit.com/r/valorantcompetitive", "reddit.com/r/chess",
            "pornpics.com", "lichess.org", "scrolller.com", "twitch.tv", "tiktok.com", "reddit.com/valorant", "youtube.com", "shopee.tw", "imgur.com"]
    });
    updateRules();
});

function updateRules() {
    // Fetch the current dynamic rules
    chrome.declarativeNetRequest.getDynamicRules((existingRules) => {
        // Extract the IDs of the existing rules to remove them
        const existingRuleIds = existingRules.map(rule => rule.id);

        // Remove existing rules using the IDs fetched
        chrome.declarativeNetRequest.updateDynamicRules({
            removeRuleIds: existingRuleIds
        }, () => {
            // After removing the existing rules, fetch the updated list of sites to block
            chrome.storage.local.get('blockedSites', (data) => {
                let newRules = data.blockedSites.map((site, index) => ({
                    id: index + 1, // Assign new IDs starting from 1
                    priority: 1,
                    action: { type: 'block' },
                    condition: { urlFilter: `*://${site}/*`, resourceTypes: ["main_frame"] }
                }));

                // Add the new rules
                chrome.declarativeNetRequest.updateDynamicRules({
                    addRules: newRules,
                    removeRuleIds: [] // No need to remove here, already removed above
                });
            });
        });
    });
}


// Example function to add a new site to the block list
function addBlockedSite(site) {
    chrome.storage.local.get('blockedSites', (data) => {
        const newSites = data.blockedSites.concat(site);
        chrome.storage.local.set({ blockedSites: newSites }, () => {
            updateRules(); // Update the rules to include the new site
        });
    });
}

// You can similarly create a function to remove sites from the list and update rules accordingly
