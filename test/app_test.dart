import 'package:alexandria/app.dart';
import 'package:alexandria/favorites/repository/favorites_repository.dart';
import 'package:alexandria/home/view/home_page.dart';
import 'package:alexandria/repository/books_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockBooksRepository extends Mock implements BooksRepository {}

class MockFavoritesRepository extends Mock implements FavoritesRepository {}

void main() {
  late BooksRepository booksRepository;
  late FavoritesRepository favoritesRepository;

  setUp(() {
    booksRepository = MockBooksRepository();
    favoritesRepository = MockFavoritesRepository();

    when(() => booksRepository.fetchAllBooks()).thenAnswer((_) async {
      return [];
    });
  });

  group('App', () {
    testWidgets('renders AlexandriaAppView', (tester) async {
      await tester.pumpWidget(
        AlexandriaApp(
          booksRepository: booksRepository,
          favoritesRepository: favoritesRepository,
        ),
      );

      expect(find.byType(AlexandriaAppView), findsOneWidget);
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('renders HomePage', (tester) async {
      await tester.pumpWidget(
        AlexandriaApp(
            booksRepository: booksRepository,
            favoritesRepository: favoritesRepository),
      );

      expect(find.byType(HomePage), findsOneWidget);
    });
  });
}
