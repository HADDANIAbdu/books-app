class Book {
  final String id;
  final String title;
  final String author;
  final String imageUrl;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.imageUrl,
  });

  // Convertir un JSON (API) vers un objet Book
  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'] as String,
      title: json['title'] as String,
      author: json['author'] as String,
      imageUrl: json['imageUrl'] as String,
    );
  }

  // Pour stocker dans SQLite (Map)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'imageUrl': imageUrl,
    };
  }

  // Pour créer un Book à partir d'un Map SQLite
  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'] as String,
      title: map['title'] as String,
      author: map['author'] as String,
      imageUrl: map['imageUrl'] as String,
    );
  }
}
