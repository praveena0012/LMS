const popularBooks = [
  {
    id: 1,
    title: "The Great Gatsby",
    author: "F. Scott Fitzgerald",
    genre: "Classic",
    cover: "https://images.unsplash.com/photo-1543002588-bfa74002ed7e?w=300&h=450&fit=crop"
  },
  {
    id: 2,
    title: "1984",
    author: "George Orwell",
    genre: "Science Fiction",
    cover: "https://images.unsplash.com/photo-1495640452828-3df6795cf69b?w=300&h=450&fit=crop"
  },
  {
    id: 3,
    title: "Pride and Prejudice",
    author: "Jane Austen",
    genre: "Romance",
    cover: "https://images.unsplash.com/photo-1512820790803-83ca734da794?w=300&h=450&fit=crop"
  },
  {
    id: 4,
    title: "The Hobbit",
    author: "J.R.R. Tolkien",
    genre: "Fantasy",
    cover: "https://images.unsplash.com/photo-1621351183012-e2f9972dd9bf?w=300&h=450&fit=crop"
  }
];

const bookGrid = document.getElementById("bookGrid");

popularBooks.forEach(function(book) {
  const card = document.createElement("div");
  card.className = "book-card";

  card.innerHTML = `
    <img src="${book.cover}" alt="${book.title}">
    <div class="book-content">
      <span class="genre-badge">${book.genre}</span>
      <h3>${book.title}</h3>
      <p>by ${book.author}</p>
      <button class="borrow-btn">Borrow Now</button>
    </div>
  `;

  bookGrid.appendChild(card);
});