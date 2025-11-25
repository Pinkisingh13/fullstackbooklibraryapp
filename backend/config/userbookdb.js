require('dotenv').config();
const mongoose = require("mongoose");

const userBookdbConnect = async () => {
  await mongoose.connect(process.env.MONGO_URI)
    .then(() => console.log("Connected to MongoDB..."))
    .catch((err) => console.error("Could not connect to MongoDB...", err))
};


const UserBookSchema = new mongoose.Schema({
  googleId: { type: String, unique: true, sparse: true },
  bookTitle: {
    type: String, required: [true, "Book title is required"], minlength: [3, 'Title must be at least 3 characters'],
    trim: true
  },
  bookDescription: { type: String, maxlength: [2000, 'Book Description must be less than 2000 characters'] },
  authors: {
    type: [String],
    validate: {
      validator: function (v) {
        return v && v.length > 0;
      },
      message: 'At least one author is required'
    }
  },
  publisher: String,
  publishedDate: String,
  pageCount: {
    type: Number,
    min: [1, 'Page count must be positive'],
    validate: {
      validator: Number.isInteger,
      message: 'Page count must be an integer'
    },
    default: 0
  },
}, {timestamps: true})

const UserBookDetail = mongoose.model("UserBook", UserBookSchema);

module.exports = {
  userBookdbConnect,
  UserBookDetail
}