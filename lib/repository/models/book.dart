import 'package:equatable/equatable.dart';

class Book extends Equatable {
  final int id;
  final String title;
  final String author;
  final String description;
  final DateTime publicationDate;

  const Book({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
    required this.publicationDate,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      title: json['title'],
      author: json['author'],
      description: json['description'],
      publicationDate: DateTime.parse(json['publication_date']),
    );
  }

  static final empty = Book(
    id: -1,
    title: '',
    author: '',
    description: '',
    publicationDate: DateTime.fromMillisecondsSinceEpoch(0),
  );

  bool get isEmpty => this == Book.empty;
  bool get isNotEmpty => this != Book.empty;

  @override
  List<Object?> get props => [
        id,
        title,
        author,
        description,
        publicationDate,
      ];
}
