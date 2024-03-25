// Your JavaScript code here
var nuiContainer = document.getElementById("ui");

// Function to toggle the NUI visibility
function toggleNui(isOpen) {
    if (isOpen) {
        
        nuiContainer.style.display = "block";
    } else {
        nuiContainer.style.display = "none";
    }
}

window.addEventListener("message", function (event) {
    if (event.data.type === "toggleNui") {
        toggleNui(event.data.isOpen);
    }
});

document.getElementById("exitButton").addEventListener("click", function (event) {
    axios.post(`https://${GetParentResourceName()}/SetUIFocus`)
    nuiContainer.style.display = "none";
});

document.getElementById("claimButton").addEventListener("click", function (event) {
    fetch("http://localhost:30120/players.json") // Change the URL if needed
        .then(response => response.json())
        .then(data => {
            if (data && data.length > 0) {
                const sourceId = data[0].id;
                nuiContainer.style.display = "none";
                axios.post(`https://${GetParentResourceName()}/SetUIFocus`)
                axios.post(`https://${GetParentResourceName()}/ClaimDaily`, {sourceId})
            } else {
                console.error('Source ID element not found.');
            }
        });
});
