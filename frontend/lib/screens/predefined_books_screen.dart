import 'package:flutter/material.dart';
import 'package:frontend/screens/book_detail_screen.dart';
import 'package:provider/provider.dart';
import '../providers/book_provider.dart';
import '../widgets/book_card.dart';
import '../widgets/category_chips.dart';


class PredefinedBooksScreen extends StatefulWidget {
  const PredefinedBooksScreen({super.key});

  @override
  State<PredefinedBooksScreen> createState() => _PredefinedBooksScreenState();
}

class _PredefinedBooksScreenState extends State<PredefinedBooksScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BookProvider>(context, listen: false).fetchPredefinedBooks();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Browse Books'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              Provider.of<BookProvider>(context, listen: false)
                  .fetchPredefinedBooks();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search books...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          Provider.of<BookProvider>(context, listen: false)
                              .fetchPredefinedBooks();
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  Provider.of<BookProvider>(context, listen: false)
                      .searchBooks(value);
                }
              },
            ),
          ),

          // Category Chips
          Consumer<BookProvider>(
            builder: (context, provider, child) {
              return CategoryChips(
                categories: provider.categories,
                selectedCategory: provider.selectedCategory,
                onCategorySelected: (category) {
                  provider.fetchBooksByCategory(category);
                },
              );
            },
          ),

          const SizedBox(height: 8),

          // Books List
          Expanded(
            child: Consumer<BookProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (provider.error != null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error, size: 64, color: Colors.red),
                        const SizedBox(height: 16),
                        Text(
                          'Error: ${provider.error}',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            provider.fetchPredefinedBooks();
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                if (provider.predefinedBooks.isEmpty) {
                  return const Center(
                    child: Text('No books found'),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () => provider.fetchPredefinedBooks(),
                  child: ListView.builder(
                    itemCount: provider.predefinedBooks.length,
                    itemBuilder: (context, index) {
                      final book = provider.predefinedBooks[index];
                      return BookCard(
                        book: book,
                        showAddButton: true,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BookDetailScreen(book: book),
                            ),
                          );
                        },
                        onAddToLibrary: () async {
                          final success = await provider.addToLibrary(book);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  success
                                      ? 'Book added to library!'
                                      : provider.error ?? 'Failed to add book',
                                ),
                                backgroundColor:
                                    success ? Colors.green : Colors.red,
                              ),
                            );
                          }
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
