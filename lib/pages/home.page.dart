import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/api_service.dart';
import '../services/db_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApiService _apiService = ApiService();
  final DbService _dbService = DbService();
  final TextEditingController _searchController = TextEditingController();
  List<Book> _books = [];
  Set<String> _favoriteBookIds = {};
  bool _isLoading = false;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    try {
      final favoriteBooks = await _dbService.getFavorites();
      setState(() {
        _favoriteBookIds = favoriteBooks.map((book) => book.id).toSet();
      });
    } catch (e) {
      print('Error loading favorites: $e');
    }
  }

  void _searchBooks() async {
    setState(() {
      _isLoading = true;
      _error = '';
      _books = [];
    });
    try {
      final books = await _apiService.searchBooks(_searchController.text.trim());
      setState(() {
        _books = books;
      });
      _loadFavorites();
    } catch (e) {
      setState(() {
        _error = 'Erreur lors de la recherche.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _toggleFavorite(Book book) async {
    if (_favoriteBookIds.contains(book.id)) {
      await _dbService.removeFavorite(book.id);
      setState(() {
        _favoriteBookIds.remove(book.id);
      });
    } else {
      await _dbService.addFavorite(book);
      setState(() {
        _favoriteBookIds.add(book.id);
      });
    }
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
        title: const Text('Recherche de Livres'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Rechercher un livre...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                      prefixIcon: const Icon(Icons.search),
                    ),
                    onSubmitted: (_) => _searchBooks(),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _searchBooks,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Icon(Icons.send, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (_isLoading)
              const Center(child: CircularProgressIndicator()),
            if (_error.isNotEmpty)
              Center(child: Text(_error, style: const TextStyle(color: Colors.red))),
            if (!_isLoading && _error.isEmpty)
              Expanded(
                child: _books.isEmpty
                    ? const Center(child: Text('Aucun livre trouvé.'))
                    : ListView.builder(
                        itemCount: _books.length,
                        itemBuilder: (context, index) {
                          final book = _books[index];
                          final isFavorite = _favoriteBookIds.contains(book.id);
                          return Card(
                            elevation: 4,
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: ListTile(
                              leading: book.imageUrl.isNotEmpty
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        book.imageUrl,
                                        width: 50,
                                        height: 70,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.book, size: 50),
                                      ),
                                    )
                                  : const Icon(Icons.book, size: 50),
                              title: Text(book.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text(book.author),
                              trailing: IconButton(
                                icon: Icon(
                                  isFavorite ? Icons.favorite : Icons.favorite_border,
                                  color: isFavorite ? Colors.red : null,
                                ),
                                onPressed: () => _toggleFavorite(book),
                                tooltip: isFavorite ? 'Retirer des favoris' : 'Ajouter aux favoris',
                              ),
                            ),
                          );
                        },
                      ),
              ),
          ],
        ),
      ),
    );
  }
}
