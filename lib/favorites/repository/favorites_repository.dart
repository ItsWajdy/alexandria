import 'package:hive_flutter/hive_flutter.dart';

/// Exception thrown when Hive hasn't been initialized before calling it.
class HiveNotInitializedException implements Exception {
  const HiveNotInitializedException(
      {this.message = 'Hive was not correctly initialized'});

  /// The associated error message.
  final String message;
}

/// Exception thrown when trying to add a book which is already in favorites.
class BookAlreadyInFavorites implements Exception {
  const BookAlreadyInFavorites({this.message = 'Book already in favorites'});

  /// The associated error message.
  final String message;
}

/// Exception thrown when trying to delete a book not in favorites.
class BookNotInFavorites implements Exception {
  const BookNotInFavorites({this.message = 'Book not found in favorites'});

  /// The associated error message.
  final String message;
}

class FavoritesRepository {
  static const String _boxName = 'favorite_books_ids';
  static late final Box _box;

  bool _hiveInitialized = false;

  Future<void> init() async {
    await Hive.initFlutter();

    _box = await Hive.openBox(_boxName);
    _hiveInitialized = true;
  }

  // Add a new book ID to Hive
  Future<void> addIdToFavorites(int id) async {
    if (!_hiveInitialized) {
      throw const HiveNotInitializedException();
    }

    if (isBookInFavorites(id)) {
      throw const BookAlreadyInFavorites();
    }

    await _box.add(id);
  }

  // Remove a book ID from Hive
  Future<void> removeIdFromFavorites(int id) async {
    if (!_hiveInitialized) {
      throw const HiveNotInitializedException();
    }

    if (!isBookInFavorites(id)) {
      throw const BookNotInFavorites();
    }

    for (int i = 0; i < _box.length; i++) {
      if (_box.values.elementAt(i) == id) {
        _box.deleteAt(i);
      }
    }
  }

  // Get all previously stored book IDs from Hive
  List<int> getFavoritesIds() {
    if (!_hiveInitialized) {
      throw const HiveNotInitializedException();
    }

    return List<int>.from(_box.values.toList());
  }

  bool isBookInFavorites(int id) {
    return _box.values.contains(id);
  }
}
