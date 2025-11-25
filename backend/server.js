const express = require("express");
require("dotenv").config();
const {userBookdbConnect, UserBookDetail} = require("./config/userbookdb");
const cors = require("cors");

const app = express();

// Middleware
app.use(cors()); 

app.use(express.json());

// Connect to MongoDB
userBookdbConnect();


app.use("/api/booklibrary", require("./routes/userbookroutes"));

const port = process.env.PORT || 8000;
app.listen(port, () =>
  console.log(`Server is listening at http://localhost:${port}`)
);


// {
// "bookTitle": "Life is too short",
// "bookDescription": "its a journey of a litle girl who is suffering from cancer.",
// "authors": ["pinki singh", "nisha pushkar"],
// "publisher": "J.K Publication",
// "publishedDate": "13/08/2012",
// "pageCount":260
// }


// {
// "googleId":
// "abYKXvCwEToC",
// "bookTitle":
// "Harry Potter",
// "bookDescription":
// "The Harry Potter books are the bestselling books of all time. In this …",
// "authors":["S. Gunelius"],
// "publisher":
// "Springer",
// "publishedDate": "2008-06-03",
// "pageCount": 214
// }