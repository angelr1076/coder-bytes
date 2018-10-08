// let textArea = document.querySelector("#textArea");
let textArea = document.getElementById("textArea");
let charEntered = document.getElementById("postCount");

function keyDown(e) {
    let length = textArea.value.length;
    charEntered.innerText = (150 - length) + " characters remaining";

    if (length >= 150) {
        event.preventDefault();
        charEntered.innerText = "Maximum characters have been reached";
    }
}