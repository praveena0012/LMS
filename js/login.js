
const loginForm = document.getElementById("loginForm");

if (loginForm) {
  loginForm.addEventListener("submit", function (e) {
    e.preventDefault();

    const username = document.getElementById("username").value.trim();
    const password = document.getElementById("password").value.trim();

    if (username === "" || password === "") {
      alert("Please fill in all fields.");
      return;
    }

    // Admin login
    if (username === "admin" && password === "123") {
      alert("Admin login successful!");
      window.location.href = "Admin/dashboard.html";
    }

    // User login
    else if (username === "user" && password === "123") {
      alert("User login successful!");
      window.location.href = "user/userdashboard.html";
    }

    // Invalid
    else {
      alert("Invalid username or password.");
    }
  });
}