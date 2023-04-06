const form = document.getElementById("contactForm");
const submitButton = form.querySelector("input[type='submit']");
const messageElement = document.createElement("div");
messageElement.setAttribute("style", "opacity: 0; transition: opacity .5s ease-in-out;");

form.addEventListener("submit", function(event) {
  event.preventDefault();

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

    if (ok) {
      messageElement.setAttribute("style", "color: green;");
      form.style.display = "none"; // hide the form if the message is a success
    } else {
      messageElement.setAttribute("style", "color: red;");
    }

    form.insertAdjacentElement("afterend", messageElement);
    
    // fade out the error message after 3 seconds
    if (!ok) {
      setTimeout(() => {
        messageElement.remove();
      }, 3000);
    }
  })
  .catch(error => console.error(error));
});
