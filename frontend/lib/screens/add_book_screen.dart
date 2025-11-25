import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/book_model.dart';
import '../providers/book_provider.dart';

class AddBookScreen extends StatefulWidget {
  const AddBookScreen({super.key});

  @override
  State<AddBookScreen> createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _authorController = TextEditingController();
  final _publisherController = TextEditingController();
  final _publishedDateController = TextEditingController();
  final _pageCountController = TextEditingController();

  final List<String> _authors = [];
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _authorController.dispose();
    _publisherController.dispose();
    _publishedDateController.dispose();
    _pageCountController.dispose();
    super.dispose();
  }

  void _addAuthor() {
    if (_authorController.text.trim().isNotEmpty) {
      setState(() {
        _authors.add(_authorController.text.trim());
        _authorController.clear();
      });
    }
  }

  void _removeAuthor(int index) {
    setState(() {
      _authors.removeAt(index);
    });
  }

  Future<void> _saveBook() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_authors.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add at least one author'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final book = Book(
      bookTitle: _titleController.text.trim(),
      bookDescription: _descriptionController.text.trim().isNotEmpty
          ? _descriptionController.text.trim()
          : null,
      authors: _authors,
      publisher: _publisherController.text.trim().isNotEmpty
          ? _publisherController.text.trim()
          : null,
      publishedDate: _publishedDateController.text.trim().isNotEmpty
          ? _publishedDateController.text.trim()
          : null,
      pageCount: _pageCountController.text.trim().isNotEmpty
          ? int.tryParse(_pageCountController.text.trim())
          : null,
    );

    try {
      final success = await Provider.of<BookProvider>(context, listen: false)
          .addToLibrary(book);

      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Book added successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                Provider.of<BookProvider>(context, listen: false).error ??
                    'Failed to add book',
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Manual Book'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Title
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Book Title *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.book),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a book title';
                }
                if (value.trim().length < 3) {
                  return 'Title must be at least 3 characters';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Description
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.description),
              ),
              maxLines: 4,
              maxLength: 2000,
            ),
            const SizedBox(height: 16),

            // Authors Section
            const Text(
              'Authors *',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            // Author Input
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _authorController,
                    decoration: const InputDecoration(
                      hintText: 'Enter author name',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                    onSubmitted: (_) => _addAuthor(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _addAuthor,
                  child: const Text('Add'),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Authors List
            if (_authors.isNotEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _authors.asMap().entries.map((entry) {
                      return Chip(
                        label: Text(entry.value),
                        deleteIcon: const Icon(Icons.close, size: 18),
                        onDeleted: () => _removeAuthor(entry.key),
                      );
                    }).toList(),
                  ),
                ),
              ),
            const SizedBox(height: 16),

            // Publisher
            TextFormField(
              controller: _publisherController,
              decoration: const InputDecoration(
                labelText: 'Publisher',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.business),
              ),
            ),
            const SizedBox(height: 16),

            // Published Date
            TextFormField(
              controller: _publishedDateController,
              decoration: const InputDecoration(
                labelText: 'Published Date',
                hintText: 'e.g., 2024-01-15',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.calendar_today),
              ),
            ),
            const SizedBox(height: 16),

            // Page Count
            TextFormField(
              controller: _pageCountController,
              decoration: const InputDecoration(
                labelText: 'Page Count',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.pages),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value != null && value.isNotEmpty) {
                  final pageCount = int.tryParse(value);
                  if (pageCount == null || pageCount < 1) {
                    return 'Please enter a valid page count';
                  }
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            // Save Button
            ElevatedButton(
              onPressed: _isLoading ? null : _saveBook,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text(
                      'Add Book',
                      style: TextStyle(fontSize: 16),
                    ),
            ),

            const SizedBox(height: 16),

            // Required fields note
            const Text(
              '* Required fields',
              style: TextStyle(
                fontSize: 12,
                fontStyle: FontStyle.italic,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
