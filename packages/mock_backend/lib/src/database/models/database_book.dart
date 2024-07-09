import 'package:hive/hive.dart';

part 'database_book.g.dart';

// TODO write documentation
@HiveType(typeId: 0)
class DatabaseBook extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String author;

  @HiveField(3)
  String description;

  @HiveField(4)
  DateTime publicationDate;

  DatabaseBook({
    required this.id,
    required this.title,
    required this.description,
    required this.author,
    required this.publicationDate,
  });

  factory DatabaseBook.fromJson(Map<String, dynamic> json) {
    return DatabaseBook(
      id: json['id'],
      title: json['title'],
      author: json['author'],
      description: json['description'],
      publicationDate: DateTime.parse(json['publication_date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'description': description,
      'publication_date': publicationDate.toString(),
    };
  }
}
