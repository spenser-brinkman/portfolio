const form = document.getElementById("contactForm");
const contactFormSection = document.getElementById("contactFormSection");
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
      hideFormSection();
    } else {
      messageElement.setAttribute("style", "color: red;");
    }

    contactFormSection.after(messageElement);
    
    // fade out the error message after 3 seconds
    if (!ok) {
      setTimeout(() => {
        messageElement.remove();
      }, 3000);
    }
  })
  .catch(error => console.error(error));
});

function hideFormSection() {
    const formHeight = contactFormSection.offsetHeight;
    const formWidth = contactFormSection.offsetWidth;
    const formTop = contactFormSection.offsetTop;
    const formLeft = contactFormSection.offsetLeft;
  
    form.animate(
      [
        { height: formHeight + "px", width: formWidth + "px", top: formTop + "px", left: formLeft + "px", opacity: 1 },
        { height: 0, width: 0, top: formTop + (formHeight / 2) + "px", left: formLeft + (formWidth / 2) + "px", opacity: 0 }
      ],
      { duration: 500 }
    ).onfinish = () => {
      contactFormSection.style.display = "none";
    };
  }