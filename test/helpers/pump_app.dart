import 'package:alexandria/all_books/all_books.dart';
import 'package:alexandria/favorites/repository/favorites_repository.dart';
import 'package:alexandria/repository/books_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network_image_mock/network_image_mock.dart';

class MockBooksRepository extends Mock implements BooksRepository {}

class MockFavoritesRepository extends Mock implements FavoritesRepository {}

extension PumpApp on WidgetTester {
  Future<void> pumpApp(
    Widget widget, {
    BooksRepository? booksRepository,
    FavoritesRepository? favoritesRepository,
  }) {
    return mockNetworkImagesFor(
      () => pumpWidget(
        MultiRepositoryProvider(
          providers: [
            RepositoryProvider.value(
                value: booksRepository ?? MockBooksRepository()),
            RepositoryProvider.value(
                value: favoritesRepository ?? MockFavoritesRepository()),
          ],
          child: MaterialApp(
            home: BlocProvider(
              create: (context) =>
                  AllBooksCubit(booksRepository ?? MockBooksRepository())
                    ..fetchAllBooks(),
              child: widget,
            ),
          ),
        ),
      ),
    );
  }
}
