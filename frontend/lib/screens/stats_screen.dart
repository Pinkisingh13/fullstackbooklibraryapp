import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/book_provider.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BookProvider>(context, listen: false).fetchStats();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Library Stats'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              Provider.of<BookProvider>(context, listen: false).fetchStats();
            },
          ),
        ],
      ),
      body: Consumer<BookProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error: ${provider.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => provider.fetchStats(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final stats = provider.stats;

          if (stats == null) {
            return const Center(
              child: Text('No statistics available'),
            );
          }

          return RefreshIndicator(
            onRefresh: () => provider.fetchStats(),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Header
                const Text(
                  '📚 My Library Overview',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // Total Books Card
                _buildStatCard(
                  icon: Icons.book,
                  title: 'Total Books',
                  value: stats.totalBooks.toString(),
                  color: Colors.blue,
                ),

                // Total Pages Card
                _buildStatCard(
                  icon: Icons.pages,
                  title: 'Total Pages',
                  value: stats.totalPages.toString(),
                  color: Colors.green,
                ),

                // Average Pages Card
                _buildStatCard(
                  icon: Icons.analytics,
                  title: 'Average Pages',
                  value: stats.avgPages.toStringAsFixed(1),
                  color: Colors.orange,
                ),

                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),

                // Book Sources
                const Text(
                  '📖 Book Sources',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                // Predefined vs Manual
                Row(
                  children: [
                    Expanded(
                      child: _buildSourceCard(
                        icon: Icons.cloud_done,
                        title: 'Pre-defined',
                        count: stats.predefinedCount,
                        total: stats.totalBooks,
                        color: Colors.purple,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildSourceCard(
                        icon: Icons.edit,
                        title: 'Manual',
                        count: stats.manualCount,
                        total: stats.totalBooks,
                        color: Colors.teal,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Reading Progress (if totalBooks > 0)
                if (stats.totalBooks > 0) ...[
                  const Text(
                    '📊 Reading Statistics',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _buildInfoRow(
                            'Total Reading Time',
                            _estimateReadingTime(stats.totalPages),
                          ),
                          const Divider(),
                          _buildInfoRow(
                            'Average Book Length',
                            '${stats.avgPages.toStringAsFixed(0)} pages',
                          ),
                          const Divider(),
                          _buildInfoRow(
                            'Collection Size',
                            '${stats.totalBooks} books',
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 32, color: color),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSourceCard({
    required IconData icon,
    required String title,
    required int count,
    required int total,
    required Color color,
  }) {
    final percentage = total > 0 ? (count / total * 100).toStringAsFixed(1) : '0';

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              count.toString(),
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              '$percentage%',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  String _estimateReadingTime(int totalPages) {
    // Assume 250 words per page, 200 words per minute
    final minutes = (totalPages * 250 / 200).round();
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;

    if (hours > 0) {
      return '$hours hrs $remainingMinutes min';
    } else {
      return '$minutes min';
    }
  }
}
