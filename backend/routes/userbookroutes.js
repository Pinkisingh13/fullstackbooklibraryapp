const express = require("express");
const router = express.Router();
const { userBookdbConnect, UserBookDetail } = require("../config/userbookdb");
require('dotenv').config();

const { initialdbConnect,
  InitialBookDetail } = require("../config/initialdb")




//get all books
router.get("/pre-defined-books", async (req, res) => {
  const preloadedbooks = await InitialBookDetail.find();
  res.json(preloadedbooks);
});

// Get all user's library books
router.get("/user-library", async (req, res) => {
  try {
    const userBooks = await UserBookDetail.find();
    res.json(userBooks);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// Filter books by category
router.get("/books-by-category/:category", async (req, res) => {
  try {
    const category = req.params.category;
    const books = await InitialBookDetail.find({ categories: category });
    res.json(books);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// Get One Single Book
router.get("/get-single-book/:id", async (req, res) => {

  try {
    const singlebook = await UserBookDetail.findById(req.params.id);

    if (!singlebook) {
      return res.status(404).json({
        message: "Book not found in your library."
      });
    }

    res.status(200).json({
      "message": "Here your book is. Enjoy Reading!",
      "singlebook": singlebook
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
})


// Create
router.post("/user-create-book", async (req, res) => {
  try {
    const userbook = new UserBookDetail(req.body);

    if (userbook.googleId) {
      const existingBook = await UserBookDetail.findOne({ googleId: userbook.googleId });
      if (existingBook) {
        return res.status(200).json({
          found: existingBook,
          message: "This book is already in your library."
        });
      }
    } else {
      const existingBook = await UserBookDetail.findOne({
        bookTitle: userbook.bookTitle,
        authors: userbook.authors
      });
      if (existingBook) {
        return res.status(200).json({
          found: existingBook,
          message: "This book is already in your library."
        });
      }
    }

    await userbook.save();
    res.status(201).json(userbook);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }

})




// UPDATE
router.put("/user-update-book/:id", async (req, res) => {
  try {
    let bookid = req.params.id;
    const userbook = await UserBookDetail.findById(bookid);

    if (!userbook) {
      return res.status(404).json({
        message: "Book not found in your library."
      });
    }

    if (userbook.googleId) {

      return res.status(400).json({
        found: userbook,
        message: "This book can not be updated, because it's predefined book."
      });

    } else {
      const existingBook = await UserBookDetail.findByIdAndUpdate(req.params.id, req.body, { new: true });
      return res.status(200).json({
        found: existingBook,
        message: "This book updated successfully."
      });

    }
  } catch (error) {
    res.status(500).json({ message: error.message });
  }

})


//DELETE
router.delete("/user-delete-book/:id", async (req, res) => {
  try {
    const deleteuserbook = await UserBookDetail.findByIdAndDelete(req.params.id);

    if (!deleteuserbook) {
      return res.status(404).json({
        message: "Book not found in your library."
      });
    }
    res.status(200).json({
      deletedbook: deleteuserbook,
      message: "This book deleted successfully."
    });


  } catch (error) {
    res.status(500).json({ message: error.message });
  }

})

// Get Aggregate
router.get("/stats/overview", async (req, res) => {
  try {
    const stats = await UserBookDetail.aggregate([
      {
        $group: {
          _id: null,
          totalBooks: { $sum: 1 },
          totalPages: { $sum: "$pageCount" },
          avgPages: { $avg: "$pageCount" },

          // Count pre-defined books
          predefinedCount: {
            $sum: { $cond: [{ $ifNull: ["$googleId", false] }, 1, 0] }
          },

          // Count manual books
          manualCount: {
            $sum: { $cond: [{ $ifNull: ["$googleId", false] }, 0, 1] }
          }
        }
      }
    ]);

    res.status(200).json(stats[0]);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

router.get("/search", async (req, res) => {
  const searchItem = req.query.q;
  const querybooks = await InitialBookDetail.find({
    $text: { $search: searchItem }
  });
  res.status(200).json({"QueryTerm": searchItem, "Query result": querybooks})
});




module.exports = router;