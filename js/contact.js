const faqs = [
  {
    question: "How do I borrow a book?",
    answer: 'Simply log in to your account, search for the book you want, and click the "Borrow" button. The book will be added to your account for 14 days.'
  },
  {
    question: "What happens if I return a book late?",
    answer: "Late returns may incur a small daily fine. We recommend returning books on time or renewing them before the due date."
  },
  {
    question: "Can I reserve a book that is currently borrowed?",
    answer: "Yes! You can place a hold on any borrowed book, and you will be notified when it becomes available."
  },
  {
    question: "How many books can I borrow at once?",
    answer: "Standard members can borrow up to 5 books at a time. Premium members can borrow up to 10 books."
  }
];

const faqList = document.getElementById("faqList");
const contactForm = document.getElementById("contactForm");
const successMessage = document.getElementById("successMessage");

faqs.forEach(function(faq) {
  const faqItem = document.createElement("details");
  faqItem.className = "faq-item";

  faqItem.innerHTML = `
    <summary>
      <span class="faq-icon">💬</span>
      <span>${faq.question}</span>
    </summary>
    <p class="faq-answer">${faq.answer}</p>
  `;

  faqList.appendChild(faqItem);
});

contactForm.addEventListener("submit", function(e) {
  e.preventDefault();

  contactForm.classList.add("hidden");
  successMessage.classList.remove("hidden");

  setTimeout(function() {
    contactForm.reset();
    successMessage.classList.add("hidden");
    contactForm.classList.remove("hidden");
  }, 3000);
});