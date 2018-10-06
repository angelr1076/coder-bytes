
let textArea = document.querySelector("#bioInput");
let charEntered = document.querySelector(".header");

function keyDown(e) {
    let length = textArea.value.length;
    charEntered.innerText = `(${150 - length} characters remaining)`;

    if (length > 150) {
        event.preventDefault();
        charEntered.innerText = "(Maximum characters have been reached)";
    }
} 

let postSize = document.querySelector("#postArea");
let numChar = document.querySelector(".postCount");

function charCount(e) {
    let length = postSize.value.length;
    numChar.innerText = `(${150 - length} characters remaining)`;

    if (length > 150) {
        event.preventDefault();
        numChar.innerText = "(Maximum characters have been reached)";
    }
} 