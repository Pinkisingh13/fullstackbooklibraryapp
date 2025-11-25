import 'package:flutter/material.dart';
import '../models/book_model.dart';
import '../services/api_service.dart';

class BookProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Book> _predefinedBooks = [];
  List<Book> _myLibrary = [];
  BookStats? _stats;

  bool _isLoading = false;
  String? _error;
  String _selectedCategory = 'All';

  List<Book> get predefinedBooks => _predefinedBooks;
  List<Book> get myLibrary => _myLibrary;
  BookStats? get stats => _stats;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get selectedCategory => _selectedCategory;

  // Available categories
  final List<String> categories = [
    'All',
    'harry potter',
    'book',
    'novel',
    'literature',
    'bestseller',
    'classic',
    'award winning',
    'popular',
    'top rated',
    'fiction bestseller',
    'science technology',
    'history world',
    'business success',
    'self improvement',
    'mystery thriller',
    'romance love',
    'fantasy adventure',
    'biography inspiring',
    'classic literature',
  ];

  // Fetch predefined books
  Future<void> fetchPredefinedBooks() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _predefinedBooks = await _apiService.getPredefinedBooks();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fetch books by category
  Future<void> fetchBooksByCategory(String category) async {
    _selectedCategory = category;
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      if (category == 'All') {
        await fetchPredefinedBooks();
      } else {
        _predefinedBooks = await _apiService.getBooksByCategory(category);
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Search books
  Future<void> searchBooks(String query) async {
    if (query.isEmpty) {
      await fetchPredefinedBooks();
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _predefinedBooks = await _apiService.searchBooks(query);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add book to library
  Future<bool> addToLibrary(Book book) async {
    try {
      final response = await _apiService.addBookToLibrary(book);

      if (response['message'] == 'This book is already in your library.') {
        _error = 'Book already in your library';
        notifyListeners();
        return false;
      }

      // Refresh library
      await fetchStats();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Delete book
  Future<bool> deleteBook(String id) async {
    try {
      await _apiService.deleteBook(id);
      await fetchStats();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Fetch user's library
  Future<void> fetchMyLibrary() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _myLibrary = await _apiService.getUserLibrary();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fetch stats
  Future<void> fetchStats() async {
    try {
      _stats = await _apiService.getStats();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
