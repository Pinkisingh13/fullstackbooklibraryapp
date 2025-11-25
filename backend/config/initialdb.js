const { text } = require("express");
const mongoose = require("mongoose");

const initialdbConnect = async()=>{await mongoose.connect('mongodb://localhost/initialbooksdata').then(() => console.log("Connected to MongoDB...")).catch((err) => console.error("Could not connect to MongoDB...", err))};


const InitialBookSchema = new mongoose.Schema({
googleId: { type: String, unique: true, sparse: true },
bookTitle: {type: String, required: true, text: true},
bookDescription: {type: String, text: true},
authors: { type: [String], text: true },
publisher: {type: String, text: true },
publishedDate: String,
pageCount: Number,
categories: [String]  
})

const InitialBookDetail = mongoose.model("InitialBook", InitialBookSchema);

module.exports = {
initialdbConnect,
InitialBookDetail
}