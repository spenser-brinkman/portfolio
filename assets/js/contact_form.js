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
      messageElement.setAttribute("style", "color: green; opacity: 1; transition: opacity .5s ease-in-out;");
    } else {
      messageElement.setAttribute("style", "color: red; opacity: 1; transition: opacity .5s ease-in-out;");
      setTimeout(() => {
        messageElement.setAttribute("style", "opacity: 0; transition: opacity .5s ease-in-out;");
      }, 3000);
    }

    submitButton.after(messageElement);
  })
  .catch(error => console.error(error));
});
