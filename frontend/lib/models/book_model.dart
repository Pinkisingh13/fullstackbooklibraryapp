class Book {
  final String? id;
  final String? googleId;
  final String bookTitle;
  final String? bookDescription;
  final List<String> authors;
  final String? publisher;
  final String? publishedDate;
  final int? pageCount;
  final List<String>? categories;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Book({
    this.id,
    this.googleId,
    required this.bookTitle,
    this.bookDescription,
    required this.authors,
    this.publisher,
    this.publishedDate,
    this.pageCount,
    this.categories,
    this.createdAt,
    this.updatedAt,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['_id'],
      googleId: json['googleId'],
      bookTitle: json['bookTitle'] ?? 'Unknown Title',
      bookDescription: json['bookDescription'],
      authors: json['authors'] != null
          ? List<String>.from(json['authors'])
          : ['Unknown Author'],
      publisher: json['publisher'],
      publishedDate: json['publishedDate'],
      pageCount: json['pageCount'],
      categories: json['categories'] != null
          ? List<String>.from(json['categories'])
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (googleId != null) 'googleId': googleId,
      'bookTitle': bookTitle,
      if (bookDescription != null) 'bookDescription': bookDescription,
      'authors': authors,
      if (publisher != null) 'publisher': publisher,
      if (publishedDate != null) 'publishedDate': publishedDate,
      if (pageCount != null) 'pageCount': pageCount,
    };
  }

  bool get isPredefined => googleId != null;
}

class BookStats {
  final int totalBooks;
  final int totalPages;
  final double avgPages;
  final int predefinedCount;
  final int manualCount;

  BookStats({
    required this.totalBooks,
    required this.totalPages,
    required this.avgPages,
    required this.predefinedCount,
    required this.manualCount,
  });

  factory BookStats.fromJson(Map<String, dynamic> json) {
    return BookStats(
      totalBooks: json['totalBooks'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      avgPages: (json['avgPages'] ?? 0).toDouble(),
      predefinedCount: json['predefinedCount'] ?? 0,
      manualCount: json['manualCount'] ?? 0,
    );
  }
}
