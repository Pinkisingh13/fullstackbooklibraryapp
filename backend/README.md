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
- ✅ MongoDB Atlas cloud database (Cluster0)

## Database

This project uses **MongoDB Atlas** (cloud database) instead of local MongoDB.

- **Cluster:** Cluster0
- **Database:** initialbooksdata
- **Collections:**
  - `initialbooks` - Pre-defined books from Google Books API
  - `userbooks` - User's personal library

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

Create a `.env` file in the `backend` folder with your MongoDB Atlas connection string:

```env
MONGO_URI=mongodb+srv://<username>:<password>@cluster0.xxxxx.mongodb.net/initialbooksdata?retryWrites=true&w=majority
PORT=8000
```

**Note:** Replace `<username>` and `<password>` with your MongoDB Atlas credentials.

4. Run the server
```bash
node server.js
```

Server will run on `http://localhost:8000`

## MongoDB Atlas Setup

If you want to set up your own MongoDB Atlas database:

1. Go to [MongoDB Atlas](https://www.mongodb.com/cloud/atlas)
2. Create a free account
3. Create a new cluster (Cluster0)
4. Create a database user (Database Access)
5. Whitelist your IP address (Network Access)
6. Get your connection string and add it to `.env`

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
