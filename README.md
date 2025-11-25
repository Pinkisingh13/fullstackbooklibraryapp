# 📚 Full-Stack Book Library App

A complete full-stack application for managing a personal book library. Browse 380+ books from Google Books API, save them to your library, create custom entries, and track your reading statistics. 

---

## 🎯 Features

### User Features
- **Browse Books:** Explore 380+ pre-defined books fetched from Google Books API
- **Category Filtering:** Filter books by 19 different categories (Fiction, Mystery, Science, etc.)
- **Search Functionality:** Search books by title, author, or description
- **Personal Library:** Add books to your personal collection
- **Manual Entry:** Create custom book entries with your own books
- **Statistics Dashboard:** View reading statistics (total books, pages, averages)
- **Delete Books:** Remove books from library with swipe gesture
- **Book Details:** View comprehensive information about each book

### Technical Features
- **RESTful API** with proper HTTP status codes
- **MongoDB Aggregation** for statistics
- **Text Search** with MongoDB indexes
- **Data Validation** on both frontend and backend
- **Error Handling** throughout the application
- **Duplicate Prevention** when adding books
- **Cloud Database** with MongoDB Atlas
- **Cloud Deployment** on Render
- **State Management** with Provider pattern
- **Responsive UI** with Material Design 3

---

## 🛠️ Tech Stack

### Backend
| Technology | Purpose |
|------------|---------|
| Node.js | Runtime environment |
| Express.js | Web framework |
| MongoDB Atlas | Cloud database |
| Mongoose | ODM for MongoDB |
| Axios | HTTP client for Google Books API |
| dotenv | Environment variable management |
| CORS | Cross-origin resource sharing |
| Render | Cloud hosting platform |

### Frontend
| Technology | Purpose |
|------------|---------|
| Flutter | Cross-platform mobile framework |
| Dart | Programming language |
| Provider | State management |
| HTTP | API communication |
| Material Design 3 | UI design system |

### External APIs
- **Google Books API** - Fetching book data

---

## 📦 NPM Packages (Backend)

```json
{
  "express": "^4.18.2",
  "mongoose": "^8.0.3",
  "axios": "^1.6.2",
  "dotenv": "^17.2.3",
  "cors": "^2.8.5"
}
```

---

## 📦 Flutter Dependencies (Frontend)

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.5+1
  http: ^1.6.0
  cupertino_icons: ^1.0.8
```

---

## 🏗️ Project Structure

### Backend Structure
```
backend/
├── config/
│   ├── initialdb.js          # Initial books database connection
│   └── userbookdb.js          # User books database connection
├── routes/
│   └── userbookroutes.js      # All API endpoints
├── initialdata.js             # Script to populate initial books
├── server.js                  # Express server setup
├── .env                       # Environment variables
├── .gitignore                # Git ignore file
└── README.md                 # Backend documentation
```

### Frontend Structure
```
frontend/
├── lib/
│   ├── main.dart             # App entry point
│   ├── models/
│   │   └── book_model.dart   # Book & BookStats models
│   ├── providers/
│   │   └── book_provider.dart # State management
│   ├── services/
│   │   └── api_service.dart  # API calls
│   ├── screens/
│   │   ├── home_screen.dart          # Main screen
│   │   ├── predefined_books_screen.dart  # Browse books
│   │   ├── my_library_screen.dart    # User's library
│   │   ├── add_book_screen.dart      # Add manual book
│   │   ├── book_detail_screen.dart   # Book details
│   │   └── stats_screen.dart         # Statistics
│   └── widgets/
│       ├── book_card.dart            # Reusable book card
│       └── category_chips.dart       # Category filter chips
├── pubspec.yaml              # Flutter dependencies
└── README.md                # Frontend documentation
```

---

## 🚀 Getting Started

### Prerequisites
- Node.js (v14 or higher)
- MongoDB Atlas account
- Flutter SDK (v3.9 or higher)
- Dart SDK

---

### Backend Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/Pinkisingh13/fullstackbooklibraryapp.git
   cd fullstackbooklibraryapp/backend
   ```

2. **Install dependencies**
   ```bash
   npm install
   ```

3. **Create `.env` file**
   ```env
   MONGO_URI=mongodb+srv://<username>:<password>@cluster0.xxxxx.mongodb.net/initialbooksdata?retryWrites=true&w=majority
   PORT=8000
   ```

4. **Populate initial books (optional)**
   ```bash
   node initialdata.js
   ```
   This fetches 380+ books from Google Books API and stores them in MongoDB.

5. **Start the server**
   ```bash
   node server.js
   ```
   Server runs on `http://localhost:8000`

---

### Frontend Setup

1. **Navigate to frontend folder**
   ```bash
   cd ../frontend
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   # For Chrome (web)
   flutter run -d chrome

   # For iOS Simulator
   flutter run -d "iPhone 15"

   # For Android Emulator
   flutter run -d emulator-5554
   ```

---

## 🌐 API Endpoints

### Books
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/booklibrary/pre-defined-books` | Get all pre-defined books |
| GET | `/api/booklibrary/books-by-category/:category` | Filter books by category |
| GET | `/api/booklibrary/search?q=query` | Search books |
| GET | `/api/booklibrary/user-library` | Get user's library |
| GET | `/api/booklibrary/get-single-book/:id` | Get single book details |

### User Library Management
| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/booklibrary/user-create-book` | Add book to library |
| PUT | `/api/booklibrary/user-update-book/:id` | Update book (manual only) |
| DELETE | `/api/booklibrary/user-delete-book/:id` | Delete book from library |

### Statistics
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/booklibrary/stats/overview` | Get library statistics |

---

## 📊 Database Schema

### InitialBook Collection (Pre-defined Books)
```javascript
{
  googleId: String (unique),
  bookTitle: String (required),
  bookDescription: String,
  authors: [String],
  publisher: String,
  publishedDate: String,
  pageCount: Number,
  categories: [String]
}
```

### UserBook Collection (User's Library)
```javascript
{
  googleId: String (unique, sparse),
  bookTitle: String (required, min: 3 chars),
  bookDescription: String (max: 2000 chars),
  authors: [String] (required),
  publisher: String,
  publishedDate: String,
  pageCount: Number (min: 1),
  createdAt: Date (auto-generated),
  updatedAt: Date (auto-generated)
}
```

---

## 🎓 What I Learned

### Backend
- Building RESTful APIs with Express.js
- MongoDB schema design with Mongoose
- MongoDB aggregation pipelines (`$group`, `$sum`, `$avg`, `$cond`)
- Text search with MongoDB indexes (`text: true`)
- Data validation with Mongoose validators
- Connecting to MongoDB Atlas (cloud database)
- Deploying Node.js app to Render
- Environment variable management
- Error handling and status codes
- Working with external APIs (Google Books API)

### Frontend
- Flutter app development
- State management with Provider pattern
- Making HTTP requests to REST APIs
- Organizing code with clean architecture
- Creating reusable widgets
- Navigation between screens
- Pull-to-refresh functionality
- Swipe-to-delete gestures
- Material Design 3 implementation

### DevOps
- Git version control
- GitHub repository management
- Cloud deployment with Render
- Environment variable configuration
- Database migration to cloud

---

## 🔧 MongoDB Features Used

### Aggregation Pipeline
```javascript
UserBookDetail.aggregate([
  {
    $group: {
      _id: null,
      totalBooks: { $sum: 1 },
      totalPages: { $sum: "$pageCount" },
      avgPages: { $avg: "$pageCount" },
      predefinedCount: {
        $sum: { $cond: [{ $ifNull: ["$googleId", false] }, 1, 0] }
      }
    }
  }
])
```

### Text Search
```javascript
InitialBookSchema.index({
  bookTitle: 'text',
  bookDescription: 'text'
});
```

### Validation
```javascript
bookTitle: {
  type: String,
  required: [true, 'Title is required'],
  minlength: [3, 'Title must be at least 3 characters']
}
```

---

## 🌟 Key Features Explanation

### Duplicate Prevention
- Books with `googleId` are checked before adding
- Manual books are checked by title + authors
- Prevents users from adding the same book twice

### Category Filtering
- 19 pre-defined categories
- Dynamic filtering with chip selection
- "All" category to show unfiltered results

### Statistics Dashboard
- Total books, pages, and averages
- Pre-defined vs Manual book counts
- Percentage calculations
- Reading time estimates

### Search Functionality
- MongoDB text search on title and description
- Case-insensitive search
- Real-time results

---

## 📱 Screenshots & Demo

*Add screenshots of your app here when available*

---

## 🚧 Future Enhancements

- [ ] User authentication (JWT)
- [ ] Multiple user support
- [ ] Reading status (Currently Reading, Completed, Want to Read)
- [ ] Book ratings and reviews
- [ ] AI-powered book recommendations
- [ ] Book cover image uploads
- [ ] Reading goals and progress tracking
- [ ] Social features (share books, follow friends)
- [ ] Export library to CSV/Excel

---

## 🐛 Known Issues

- Render free tier: API may take 30-60 seconds to wake up after inactivity
- Initial book fetch can be slow (380+ books)

---

## 📝 License

This is a personal learning project. Feel free to use the code for educational purposes.

---

## 👤 Author

**Pinki Singh**

- GitHub: [@Pinkisingh13](https://github.com/Pinkisingh13)
- LinkedIn: [Your LinkedIn](https://linkedin.com/in/your-profile)

---

## 🙏 Acknowledgments

- Google Books API for book data
- MongoDB documentation
- Flutter documentation
- Stack Overflow community

---

## 📧 Contact

For any queries or feedback, feel free to reach out!

**Repository:** [https://github.com/Pinkisingh13/fullstackbooklibraryapp](https://github.com/Pinkisingh13/fullstackbooklibraryapp)

---

**⭐ If you found this project helpful, please give it a star!**
