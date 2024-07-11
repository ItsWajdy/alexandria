import 'package:hive_flutter/hive_flutter.dart';

/// Exception thrown when Hive hasn't been initialized before calling it.
class HiveNotInitializedException implements Exception {
  const HiveNotInitializedException(
      {this.message = 'Hive was not correctly initialized'});

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

    await _box.add(id);
  }

  Future<void> removeIdFromFavorites(int id) async {
    if (!_hiveInitialized) {
      throw const HiveNotInitializedException();
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
}
