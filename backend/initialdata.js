

const axios = require('axios');

const { initialdbConnect,
  InitialBookDetail } = require("./config/initialdb")



async function getInitialBookData() {

  initialdbConnect();

  const q = [
    "harry potter",
    "book",
    "novel",
    "literature",
    "bestseller",
    "classic",
    "award winning",
    "popular",
    "top rated",
    "fiction bestseller",
    "science technology",
    "history world",
    "business success",
    "self improvement",
    "mystery thriller",
    "romance love",
    "fantasy adventure",
    "biography inspiring",
    "classic literature"
  ];

  try {
    for (const query of q) {
      console.log(`Fetching books for: ${query}`);
      const response = await axios.get(`https://www.googleapis.com/books/v1/volumes?q=${encodeURIComponent(query)}&maxResults=40`)

      const responseData = response.data.items || [];
      console.log(responseData);

      for (const item of responseData) {
        const volume = item.volumeInfo;

        const found = await InitialBookDetail.findOne({ googleId: item.id })

        if (found) {
          console.log(`Already exists: ${volume.title}`);
          continue;
        }


        const newBook = new InitialBookDetail({
          googleId: item.id,
          bookTitle: volume.title || "No Title",
          bookDescription: volume.description || "",
          authors: volume.authors || [],
          publisher: volume.publisher,
          publishedDate: volume.publishedDate || "",
          pageCount: volume.pageCount || null,
          categories: [query]  // Save the query as category
        });

        await newBook.save();
        console.log(`Inserted: ${newBook.bookTitle}`);



      };

      await new Promise(resolve => setTimeout(resolve, 1000));

    }

  } catch (error) {
    console.error("Error:", error.message);
    if (error.response) {
      console.error("API Error:", error.response.data);
      console.error("Status:", error.response.status);
    }
  }

}

getInitialBookData();