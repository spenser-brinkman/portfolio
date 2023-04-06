const form = document.getElementById("contactForm");
const submitButton = form.querySelector("input[type='submit']");
const messageElement = document.createElement("div");

form.addEventListener("submit", function(event) {
  event.preventDefault();

  const formData = new FormData(form);

  fetch(form.action, {
    method: form.method,
    body: formData
  })
  .then(response => {
    // Capture the response in a variable to pass it along to the next `then` block
    return response.json().then(data => ({ ok: response.ok, data }));
  })
  .then(({ ok, data }) => {
    // create a new message element and insert it after the submit button
    messageElement.innerText = data.message;
    messageElement.style.color = ok ? "green" : "red";
    submitButton.after(messageElement);

    // add a fade-in effect for both success and error messages
    messageElement.style.opacity = "0";
    setTimeout(function() {
      messageElement.style.opacity = "1";
    }, 100);

    if (!ok) {
      setTimeout(function() {
        // add a fade-out effect for error messages only
        messageElement.style.opacity = "0";
        setTimeout(function() {
          messageElement.remove();
        }, 500);
      }, 5000);
    }
  })
  .catch(error => console.error(error));
});