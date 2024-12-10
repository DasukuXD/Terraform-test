const express = require('express');
const app = express();

app.use(express.json());

let books = [
  { id: 1, title: 'Harry Potter and the Philosopher\'s Stone', author: 'J.K. Rowling' },
  { id: 2, title: 'To Kill a Mockingbird', author: 'Harper Lee' },
  { id: 3, title: 'The Great Gatsby', author: 'F. Scott Fitzgerald' }
];

app.get('/api/books', (req, res) => {
  res.json(books);
});

app.listen(3000, () => {
  console.log(`Server is running on port 3000`);
});