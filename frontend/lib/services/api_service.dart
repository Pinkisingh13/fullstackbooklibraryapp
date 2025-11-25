import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/book_model.dart';

class ApiService {
  // Use your deployed Render URL
  static const String baseUrl = 'https://fullstackbooklibraryapp.onrender.com/api/booklibrary';

  // For local testing, uncomment this:
  // static const String baseUrl = 'http://localhost:8000/api/booklibrary';

  // Get all predefined books
  Future<List<Book>> getPredefinedBooks() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/pre-defined-books'));

      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((book) => Book.fromJson(book)).toList();
      } else {
        throw Exception('Failed to load books: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching predefined books: $e');
    }
  }

  // Get user's library books
  Future<List<Book>> getUserLibrary() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/user-library'));

      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((book) => Book.fromJson(book)).toList();
      } else {
        throw Exception('Failed to load user library: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching user library: $e');
    }
  }

  // Get books by category
  Future<List<Book>> getBooksByCategory(String category) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/books-by-category/$category')
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((book) => Book.fromJson(book)).toList();
      } else {
        throw Exception('Failed to load books by category');
      }
    } catch (e) {
      throw Exception('Error fetching books by category: $e');
    }
  }

  // Search books
  Future<List<Book>> searchBooks(String query) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/search?q=$query')
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        List<dynamic> books = jsonData['Query result'] ?? [];
        return books.map((book) => Book.fromJson(book)).toList();
      } else {
        throw Exception('Failed to search books');
      }
    } catch (e) {
      throw Exception('Error searching books: $e');
    }
  }

  // Add book to user library
  Future<Map<String, dynamic>> addBookToLibrary(Book book) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/user-create-book'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(book.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to add book: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error adding book: $e');
    }
  }

  // Get single book
  Future<Book> getBook(String id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/get-single-book/$id')
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        return Book.fromJson(jsonData['singlebook']);
      } else {
        throw Exception('Book not found');
      }
    } catch (e) {
      throw Exception('Error fetching book: $e');
    }
  }

  // Update book
  Future<Map<String, dynamic>> updateBook(String id, Book book) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/user-update-book/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(book.toJson()),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        Map<String, dynamic> errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to update book');
      }
    } catch (e) {
      throw Exception('Error updating book: $e');
    }
  }

  // Delete book
  Future<void> deleteBook(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/user-delete-book/$id')
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to delete book');
      }
    } catch (e) {
      throw Exception('Error deleting book: $e');
    }
  }

  // Get stats
  Future<BookStats> getStats() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/stats/overview')
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        return BookStats.fromJson(jsonData);
      } else {
        throw Exception('Failed to load stats');
      }
    } catch (e) {
      throw Exception('Error fetching stats: $e');
    }
  }
}
