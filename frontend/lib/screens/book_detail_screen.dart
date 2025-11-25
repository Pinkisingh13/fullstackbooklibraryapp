import 'package:flutter/material.dart';
import '../models/book_model.dart';
import 'package:provider/provider.dart';
import '../providers/book_provider.dart';

class BookDetailScreen extends StatelessWidget {
  final Book book;

  const BookDetailScreen({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Details'),
        actions: [
          if (book.isPredefined)
            IconButton(
              icon: const Icon(Icons.add_circle),
              tooltip: 'Add to Library',
              onPressed: () async {
                final provider = Provider.of<BookProvider>(context, listen: false);
                final success = await provider.addToLibrary(book);

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        success
                            ? 'Book added to library!'
                            : provider.error ?? 'Failed to add book',
                      ),
                      backgroundColor: success ? Colors.green : Colors.red,
                    ),
                  );
                }
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                book.bookTitle,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              // Authors
              Row(
                children: [
                  const Icon(Icons.person, size: 20, color: Colors.grey),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      book.authors.join(', '),
                      style: const TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Book Type Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: book.isPredefined ? Colors.blue : Colors.green,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      book.isPredefined ? Icons.cloud_done : Icons.edit,
                      size: 16,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      book.isPredefined ? 'Pre-defined Book' : 'Manual Entry',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Description
              if (book.bookDescription != null &&
                  book.bookDescription!.isNotEmpty) ...[
                const Text(
                  'Description',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      book.bookDescription!,
                      style: const TextStyle(fontSize: 16, height: 1.5),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // Details Section
              const Text(
                'Details',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      if (book.publisher != null) ...[
                        _buildDetailRow(
                          icon: Icons.business,
                          label: 'Publisher',
                          value: book.publisher!,
                        ),
                        const Divider(),
                      ],
                      if (book.publishedDate != null) ...[
                        _buildDetailRow(
                          icon: Icons.calendar_today,
                          label: 'Published',
                          value: book.publishedDate!,
                        ),
                        const Divider(),
                      ],
                      if (book.pageCount != null) ...[
                        _buildDetailRow(
                          icon: Icons.pages,
                          label: 'Pages',
                          value: book.pageCount.toString(),
                        ),
                        // const Divider(),
                      ],
                      // if (book.googleId != null) ...[
                      //   _buildDetailRow(
                      //     icon: Icons.fingerprint,
                      //     label: 'Google ID',
                      //     value: book.googleId!,
                      //   ),
                      //   const Divider(),
                      // ],
                      if (book.createdAt != null) ...[
                        _buildDetailRow(
                          icon: Icons.access_time,
                          label: 'Added',
                          value: _formatDate(book.createdAt!),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              // Categories
              if (book.categories != null && book.categories!.isNotEmpty) ...[
                const SizedBox(height: 24),
                const Text(
                  'Categories',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: book.categories!.map((category) {
                    return Chip(
                      label: Text(category),
                      backgroundColor: Colors.blue.shade50,
                    );
                  }).toList(),
                ),
              ],

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
