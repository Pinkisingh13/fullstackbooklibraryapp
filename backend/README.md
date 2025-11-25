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
- MongoDB Atlas (Cloud Database)
- Mongoose
- Axios
- CORS
- Render (Deployment Platform)

## Deployment

This backend is deployed on **Render** (cloud hosting platform).

### Live API URL

```
https://fullstackbooklibraryapp.onrender.com
```

### Deployment Information

- **Platform:** Render
- **Environment:** Production
- **Database:** MongoDB Atlas (Cluster0)
- **Port:** Dynamic (assigned by Render, defaults to 10000)
- **Environment Variables:** Set in Render dashboard

### Accessing the Deployed API

The API is accessible at:
```
https://fullstackbooklibraryapp.onrender.com/api/booklibrary
```

**Example Endpoints:**
- `GET https://fullstackbooklibraryapp.onrender.com/api/booklibrary/pre-defined-books`
- `GET https://fullstackbooklibraryapp.onrender.com/api/booklibrary/search?q=harry`
- `POST https://fullstackbooklibraryapp.onrender.com/api/booklibrary/user-create-book`

### How to Deploy to Render

If you want to deploy your own version:

1. **Push code to GitHub** (ensure `node_modules` and `.env` are in `.gitignore`)

2. **Create a Render account** at [render.com](https://render.com)

3. **Create a new Web Service:**
   - Connect your GitHub repository
   - Choose "Node" as environment
   - Build Command: `npm install`
   - Start Command: `node server.js`

4. **Set Environment Variables** in Render dashboard:
   ```
   MONGO_URI=mongodb+srv://<username>:<password>@cluster0.xxxxx.mongodb.net/initialbooksdata?retryWrites=true&w=majority
   PORT=10000
   ```

5. **Deploy!** Render will automatically deploy on every push to main branch

### Why Render?

- ✅ **Free tier available** - Perfect for learning projects
- ✅ **Auto-deployment** - Deploys automatically when you push to GitHub
- ✅ **Easy setup** - No complex configuration needed
- ✅ **HTTPS included** - Free SSL certificates
- ✅ **Environment variables** - Secure configuration management
- ✅ **Auto-scaling** - Handles traffic automatically

**Note:** Render free tier services may spin down after 15 minutes of inactivity. First request might take 30-60 seconds to wake up the service.

## Author

Pinki Singh
