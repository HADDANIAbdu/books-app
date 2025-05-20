import 'package:flutter/material.dart';
import '../models/book.dart';

class DetailPage extends StatelessWidget {
  final Book book;

  const DetailPage({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(book.title),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: book.imageUrl.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        book.imageUrl,
                        height: 200,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.book, size: 150),
                      ),
                    )
                  : const Icon(Icons.book, size: 150),
            ),
            const SizedBox(height: 20),
            Text(
              book.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Par ${book.author}',
              style: TextStyle(
                fontSize: 18,
                fontStyle: FontStyle.italic,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 16),
            // Add more book details here if available in the Book model
            // Example: Description, published date, etc.
            // Text(
            //   'Description:',
            //   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            // ),
            // SizedBox(height: 8),
            // Text(book.description ?? 'Aucune description disponible.'),
          ],
        ),
      ),
    );
  }
}
