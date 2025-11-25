# Book Library Backend

A Node.js + Express + MongoDB backend for managing a personal book library.

## Features

- ✅ CRUD operations for books
- ✅ Pre-defined books from Google Books API
- ✅ Category filtering
- ✅ Text search
- ✅ User library management
- ✅ Statistics/Aggregations
- ✅ Data validation

## Installation

1. Clone the repository
```bash
git clone <your-repo-url>
cd backend
```

2. Install dependencies
```bash
npm install
```

3. Create `.env` file
```bash
MONGO_URI=mongodb://localhost:27017/booklibrary
```

4. Start MongoDB
```bash
mongod
```

5. Run the server
```bash
node server.js
```

Server will run on `http://localhost:8000`

## API Endpoints

### Books
- `GET /api/booklibrary/pre-defined-books` - Get all pre-defined books
- `GET /api/booklibrary/books-by-category/:category` - Filter by category
- `GET /api/booklibrary/search?q=query` - Search books

### User Library
- `POST /api/booklibrary/user-create-book` - Add book to library
- `GET /api/booklibrary/get-single-book/:id` - Get single book
- `PUT /api/booklibrary/user-update-book/:id` - Update book
- `DELETE /api/booklibrary/user-delete-book/:id` - Delete book

### Statistics
- `GET /api/booklibrary/stats/overview` - Get library statistics

## Technologies

- Node.js
- Express.js
- MongoDB
- Mongoose
- Axios
- CORS

## Author

Pinki Singh
