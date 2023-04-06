const form = document.getElementById("contactForm");

form.addEventListener("submit", function (event) {
    event.preventDefault();

    const formData = new FormData(form);

    fetch(form.action, {
        method: form.method,
        body: formData
    })
    .then(response => response.json()) // parse the HTTP response as JSON
    .then(data => {
        // create a pop-up window and display the results
        const popup = window.open("", "Popup", "width=400,height=400");
        popup.document.write(JSON.stringify(data));
    })
    .catch(error => console.error(error));
});