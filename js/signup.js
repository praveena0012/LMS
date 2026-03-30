const nicFront = document.getElementById("nicFront");
const nicBack = document.getElementById("nicBack");
const frontText = document.getElementById("frontText");
const backText = document.getElementById("backText");
const signupForm = document.getElementById("signupForm");

if (nicFront) {
  nicFront.addEventListener("change", function () {
    if (this.files.length > 0) {
      frontText.textContent = "📤 " + this.files[0].name;
    } else {
      frontText.textContent = "📤 Click to upload NIC Front";
    }
  });
}

if (nicBack) {
  nicBack.addEventListener("change", function () {
    if (this.files.length > 0) {
      backText.textContent = "📤 " + this.files[0].name;
    } else {
      backText.textContent = "📤 Click to upload NIC Back";
    }
  });
}

if (signupForm) {
  signupForm.addEventListener("submit", function (e) {
    e.preventDefault();
    alert("Registration form submitted!");
  });
}