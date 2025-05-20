import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/book.dart';

class ApiService {
  static const String _baseUrl = 'https://www.googleapis.com/books/v1/volumes';

  // Recherche de livres par mot-clé
  Future<List<Book>> searchBooks(String query) async {
    final url = Uri.parse('$_baseUrl?q=$query');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List items = data['items'] ?? [];
      return items.map<Book>((item) {
        final volumeInfo = item['volumeInfo'] ?? {};
        return Book(
          id: item['id'] ?? '',
          title: volumeInfo['title'] ?? 'Titre inconnu',
          author: (volumeInfo['authors'] != null && volumeInfo['authors'].isNotEmpty)
              ? volumeInfo['authors'][0]
              : 'Auteur inconnu',
          imageUrl: volumeInfo['imageLinks'] != null
              ? volumeInfo['imageLinks']['thumbnail'] ?? ''
              : '',
        );
      }).toList();
    } else {
      throw Exception('Erreur lors de la récupération des livres');
    }
  }
}
