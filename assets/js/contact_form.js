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
  .then(response => response.json())
  .then(data => {
    // create a new message element and insert it after the submit button
    messageElement.innerText = data.message;
    messageElement.style.color = response.ok ? "green" : "red";
    submitButton.after(messageElement);

    // if it's an error message, remove it after 5 seconds
    if (!response.ok) {
      setTimeout(function() {
        messageElement.remove();
      }, 5000);
    }
  })
  .catch(error => console.error(error));
});
