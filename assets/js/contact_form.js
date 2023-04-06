const form = document.getElementById("contactForm");
const submitButton = form.querySelector("input[type='submit']");
const messageElement = document.createElement("div");

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

    // apply the appropriate styles to the message element based on the response status
    if (ok) {
      messageElement.setAttribute("style", "color: green;");
    } else {
      messageElement.setAttribute("style", "color: red;");
    }

    // add the message element to the DOM
    submitButton.after(messageElement);
  })
  .catch(error => console.error(error));
});
