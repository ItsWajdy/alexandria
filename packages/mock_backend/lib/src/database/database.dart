import 'package:hive_flutter/adapters.dart';
import 'package:mock_backend/src/database/models/database_book.dart';
import 'package:mock_backend/src/seed_data/books_data.dart';

export 'models/models.dart';

abstract class DatabaseException implements Exception {
  const DatabaseException(this.message);

  /// The associated error message.
  final String message;
}

/// Exception thrown when Hive hasn't been initialized before calling it.
class HiveNotInitializedException extends DatabaseException {
  const HiveNotInitializedException()
      : super('Hive was not correctly initialized');
}

/// Exception thrown when trying to add an existing book into the database.
class BookAlreadyExistsException extends DatabaseException {
  const BookAlreadyExistsException() : super('Book Already Exists');
}

/// Exception thrown when trying to read a book that doesn't exist in database.
class BookNotInDatabaseException extends DatabaseException {
  const BookNotInDatabaseException() : super('Book Not In Database');
}

class Database {
  static bool _hiveInitialized = false;

  static const String _booksBoxName = 'books_database';
  static const String _lastBookIdBoxName = 'last_book_id_database';
  static const String _lastBookIdKey = 'last_book_id';

  static late final Box _booksBox;
  static late final Box _lastBookIdBox;

  /// Initialize Hive and populate the database with initial data if database is empty
  static Future<void> init() async {
    // Initiate Hive for Flutter and register the DatabaseBookAdapter
    await Hive.initFlutter();
    Hive.registerAdapter(DatabaseBookAdapter());

    // Open the books box and the last index box
    _booksBox = await Hive.openBox(_booksBoxName);
    _lastBookIdBox = await Hive.openBox(_lastBookIdBoxName);

    // If books box is empty populate the database with seed data
    if (_booksBox.isEmpty) {
      await _populateFromSeedData();
      await _lastBookIdBox.put(_lastBookIdKey, _booksBox.length);
    }

    // Finished initialization
    _hiveInitialized = true;
  }

  static Future<void> _populateFromSeedData() async {
    List<DatabaseBook> json =
        BooksData.data.map((e) => DatabaseBook.fromJson(e)).toList();
    await _booksBox.addAll(json);
  }

  /// Get DatabaseBook from database by its ID and throw error on failure
  static DatabaseBook get(int id) {
    if (!_hiveInitialized) {
      throw HiveNotInitializedException();
    }

    DatabaseBook? book = _booksBox.values.where((e) => e.id == id).firstOrNull;

    if (book == null) {
      throw BookNotInDatabaseException();
    }

    return book;
  }

  /// Get DatabaseBook from database by its ID and return null on failure
  static DatabaseBook? getOrNull(int id) {
    if (!_hiveInitialized) {
      throw HiveNotInitializedException();
    }

    DatabaseBook? book = _booksBox.values.where((e) => e.id == id).firstOrNull;

    if (book == null) {
      return null;
    }

    return book;
  }

  /// Get all DatabaseBooks from database
  static List<DatabaseBook> getAll() {
    if (!_hiveInitialized) {
      throw HiveNotInitializedException();
    }

    return List<DatabaseBook>.from(_booksBox.values);
  }

  /// Does database contain DatabaseBook with ID
  static bool containsId(int id) {
    DatabaseBook? existingBook = getOrNull(id);
    return existingBook != null;
  }

  /// Does database contain DatabaseBook
  static bool contains(DatabaseBook book) {
    return containsId(book.id);
  }

  /// Add DatabaseBook to database
  static Future<void> add(
    String title,
    String author,
    String description,
    String coverImagePath,
    DateTime publicationDate,
  ) async {
    if (!_hiveInitialized) {
      throw HiveNotInitializedException();
    }

    DatabaseBook book = DatabaseBook(
      id: _lastBookIdBox.get(_lastBookIdKey),
      title: title,
      author: author,
      description: description,
      publicationDate: publicationDate,
      image: coverImagePath,
    );

    await _booksBox.add(book);

    // Increment last book ID by one
    int lastStoredBookId = await _lastBookIdBox.get(_lastBookIdKey);
    await _lastBookIdBox.put(_lastBookIdKey, lastStoredBookId + 1);
  }

  /// Add list of DatabaseBooks to database
  static Future<void> addAll(List<DatabaseBook> books) async {
    if (!_hiveInitialized) {
      throw HiveNotInitializedException();
    }
    for (int i = 0; i < books.length; i++) {
      if (contains(books[i])) {
        throw BookAlreadyExistsException();
      }
    }

    await _booksBox.addAll(books);

    // Increment last book ID by number of added books
    int lastStoredBookId = await _lastBookIdBox.get(_lastBookIdKey);
    await _lastBookIdBox.put(_lastBookIdKey, lastStoredBookId + books.length);
  }

  /// Update DatabaseBook in database
  static Future<void> update(DatabaseBook book) async {
    if (!_hiveInitialized) {
      throw HiveNotInitializedException();
    }
    if (!contains(book)) {
      throw BookNotInDatabaseException();
    }

    DatabaseBook existingBook = get(book.id);
    existingBook.copyFrom(book);

    existingBook.save();
  }

  /// Delete DatabaseBook from database
  static Future<void> delete(int id) async {
    if (!_hiveInitialized) {
      throw HiveNotInitializedException();
    }
    if (!containsId(id)) {
      throw BookNotInDatabaseException();
    }

    DatabaseBook existingBook = get(id);

    existingBook.delete();
  }
}
