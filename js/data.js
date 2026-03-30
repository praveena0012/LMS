let selectedCategory = "All";

function toggleDropdown() {
  const menu = document.getElementById("dropdownMenu");
  menu.style.display = menu.style.display === "block" ? "none" : "block";
}

function selectCategory(category) {
  selectedCategory = category;
  document.getElementById("selectedCategory").innerText = category;
  document.getElementById("dropdownMenu").style.display = "none";
  filterBooks();
}

function filterBooks() {
  const input = document.getElementById("searchInput").value.toLowerCase();
  const books = document.querySelectorAll(".book-card");
  let visibleCount = 0;

  books.forEach(book => {
    const title = book.getAttribute("data-title").toLowerCase();
    const author = book.getAttribute("data-author").toLowerCase();
    const category = book.getAttribute("data-category");

    const matchesSearch =
      title.includes(input) || author.includes(input);

    const matchesCategory =
      selectedCategory === "All" || category === selectedCategory;

    if (matchesSearch && matchesCategory) {
      book.style.display = "block";
      visibleCount++;
    } else {
      book.style.display = "none";
    }
  });

  showNoResults(visibleCount);
}

function showNoResults(count) {
  const grid = document.getElementById("booksGrid");
  let noResults = document.getElementById("noResults");

  if (count === 0) {
    if (!noResults) {
      noResults = document.createElement("div");
      noResults.id = "noResults";
      noResults.className = "no-results";
      noResults.innerText = "No books found.";
      grid.appendChild(noResults);
    }
  } else {
    if (noResults) {
      noResults.remove();
    }
  }
}

function borrowBook(bookName) {
  alert(bookName + " borrowed successfully!");
}

window.onclick = function (e) {
  const dropdown = document.getElementById("dropdownMenu");
  const button = document.querySelector(".category-btn");

  if (dropdown && button && !button.contains(e.target) && !dropdown.contains(e.target)) {
    dropdown.style.display = "none";
  }
};

/*admin panel*/
function clearAddBookForm() {
  const form = document.getElementById("addBookForm");
  if (form) {
    form.reset();
  }
}

document.addEventListener("DOMContentLoaded", function () {
  const form = document.getElementById("addBookForm");

  if (form) {
    form.addEventListener("submit", function (e) {
      e.preventDefault();

      const bookName = document.getElementById("bookName").value.trim();
      const authorName = document.getElementById("authorName").value.trim();
      const category = document.getElementById("category").value.trim();
      const copies = document.getElementById("copies").value.trim();
      const imageUrl = document.getElementById("imageUrl").value.trim();

      if (!bookName || !authorName || !category || !copies) {
        alert("Please fill all required fields.");
        return;
      }

      const newBook = {
        title: bookName,
        author: authorName,
        category: category,
        totalCopies: Number(copies),
        availableCopies: Number(copies),
        imageUrl: imageUrl || "https://via.placeholder.com/60x90"
      };

      let books = JSON.parse(localStorage.getItem("books")) || [];
      books.push(newBook);
      localStorage.setItem("books", JSON.stringify(books));

      alert("Book added successfully!");
      form.reset();
    });
  }
});
const books = [
  {
    title: "The Great Gatsby",
    author: "F. Scott Fitzgerald",
    category: "Classic",
    totalCopies: 5,
    available: 3,
    image: "https://images.unsplash.com/photo-1544947950-fa07a98d237f?w=300&auto=format&fit=crop&q=60"
  },
  {
    title: "To Kill a Mockingbird",
    author: "Harper Lee",
    category: "Classic",
    totalCopies: 4,
    available: 4,
    image: "https://images.unsplash.com/photo-1512820790803-83ca734da794?w=300&auto=format&fit=crop&q=60"
  },
  {
    title: "1984",
    author: "George Orwell",
    category: "Science Fiction",
    totalCopies: 8,
    available: 1,
    image: "https://images.unsplash.com/photo-1526243741027-444d633d7365?w=300&auto=format&fit=crop&q=60"
  },
  {
    title: "Pride and Prejudice",
    author: "Jane Austen",
    category: "Romance",
    totalCopies: 7,
    available: 5,
    image: "https://images.unsplash.com/photo-1516979187457-637abb4f9353?w=300&auto=format&fit=crop&q=60"
  },
  {
    title: "The Hobbit",
    author: "J.R.R. Tolkien",
    category: "Fantasy",
    totalCopies: 3,
    available: 0,
    image: "https://images.unsplash.com/photo-1513001900722-370f803f498d?w=300&auto=format&fit=crop&q=60"
  }
];

const bookTableBody = document.getElementById("bookTableBody");

function loadBooks() {
  bookTableBody.innerHTML = "";

  books.forEach((book, index) => {
    const availabilityClass = book.available === 0 ? "available-red" : "available-green";

    const row = document.createElement("tr");

    row.innerHTML = `
      <td>
        <div class="book-cell">
          <img src="${book.image}" alt="${book.title}" class="book-image">
        </div>
      </td>
      <td class="title-cell">${book.title}</td>
      <td class="author-cell">${book.author}</td>
      <td class="category-cell">${book.category}</td>
      <td>${book.totalCopies}</td>
      <td class="${availabilityClass}">${book.available}</td>
      <td>
        <div class="actions">
          <button class="edit-btn" onclick="editBook(${index})">
            <i class="fa-regular fa-pen-to-square"></i>
          </button>
          <button class="delete-btn" onclick="deleteBook(${index})">
            <i class="fa-regular fa-trash-can"></i>
          </button>
        </div>
      </td>
    `;

    bookTableBody.appendChild(row);
  });
}

function editBook(index) {
  alert("Edit clicked for: " + books[index].title);
}

function deleteBook(index) {
  const confirmDelete = confirm("Are you sure you want to delete " + books[index].title + "?");

  if (confirmDelete) {
    books.splice(index, 1);
    loadBooks();
  }
}

loadBooks();