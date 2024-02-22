// document.addEventListener('DOMContentLoaded', function () {
//     const button = document.getElementById('toggleButton');

//     chrome.storage.local.get('isBlockingEnabled', data => {
//         button.textContent = data.isBlockingEnabled ? 'Disable Blocking' : 'Enable Blocking';
//     });

//     button.addEventListener('click', () => {
//         chrome.runtime.sendMessage({ command: "toggle" }, response => {
//             button.textContent = response.isBlockingEnabled ? 'Disable Blocking' : 'Enable Blocking';
//         });
//     });
// });
