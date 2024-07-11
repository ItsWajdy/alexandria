import 'package:alexandria/api_service/books_api_service.dart';
import 'package:alexandria/app.dart';
import 'package:alexandria/repository/books_repository.dart';
import 'package:alexandria/favorites/repository/favorites_repository.dart';
import 'package:flutter/material.dart';
import 'package:mock_backend/mock_backend.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await MockDio.init();

  FavoritesRepository favoritesRepository = FavoritesRepository();
  await favoritesRepository.init();

  runApp(
    AlexandriaApp(
      booksRepository: BooksRepository(
        booksApiService: BooksApiService(dio: MockDio()),
      ),
      favoritesRepository: favoritesRepository,
    ),
  );
}
