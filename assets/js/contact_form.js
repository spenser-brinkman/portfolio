const form = document.getElementById("contactForm");
const submitButton = form.querySelector("input[type='submit']");
const messageElement = document.createElement("div");

// add CSS rules for the message element
const messageStyles = `
  display: inline;
  transform: translate(-50%, -50%);
  color: white;
  transition: opacity 0.5s ease-in-out;
  z-index: 10;
`;

// add CSS rules for the success message
const successStyles = `
  background-color: green;
`;

// add CSS rules for the error message
const errorStyles = `
  background-color: red;
`;

// apply the message styles to the message element
messageElement.setAttribute("style", messageStyles);

form.addEventListener("submit", function(event) {
  event.preventDefault(); // prevent the default form submission behavior

  const formData = new FormData(form);

  fetch(form.action, {
    method: form.method,
    body: formData
  })
  .then(response => {
    return response.json().then(data => ({ ok: response.ok, data }));
  })
  .then(({ ok, data }) => {
    messageElement.innerText = data.message;
    messageElement.classList.add("message");

    // apply the appropriate styles to the message element based on the response status
    if (ok) {
      messageElement.setAttribute("style", messageStyles + successStyles);
    } else {
      messageElement.setAttribute("style", messageStyles + errorStyles);
    }

    // add the message element to the DOM
    submitButton.after(messageElement);
    messageElement.classList.add("message-show");

    // trigger a reflow to apply the new styles before transitioning the opacity
    messageElement.offsetHeight;

    // fade in the message
    messageElement.style.opacity = "1";

    if (!ok) {
      setTimeout(function() {
        // fade out the message after 5 seconds
        messageElement.style.opacity = "0";
        setTimeout(function() {
          messageElement.remove();
        }, 500);
      }, 3000);
    }
  })
  .catch(error => console.error(error));
});
