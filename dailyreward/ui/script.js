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
        .then(response => {
            console.log("SetUIFocus request success:", response.data);
            nuiContainer.style.display = "none";
        })
        .catch(error => {
            console.error("SetUIFocus request error:", error);
        });
});

document.getElementById("claimButton").addEventListener("click", function (event) {
    // Replace the URL and data as needed
    axios.post(`https://${GetParentResourceName()}/ClaimDaily`, {})
        .then(response => {
            console.log("ClaimDaily request success:", response.data);
            nuiContainer.style.display = "none";
        })
        .catch(error => {
            console.error("ClaimDaily request error:", error);
        });
        axios.post(`https://${GetParentResourceName()}/SetUIFocus`)
        .then(response => {
            console.log("SetUIFocus request success:", response.data);
            nuiContainer.style.display = "none";
        })
        .catch(error => {
            console.error("SetUIFocus request error:", error);
        });
});
