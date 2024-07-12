import 'dart:io';

import 'package:alexandria/all_books/widgets/book_preview.dart';
import 'package:alexandria/favorites/favorites.dart';
import 'package:alexandria/favorites/favorites_cubit/favorites_state.dart';
import 'package:alexandria/repository/books_repository.dart';
import 'package:alexandria/repository/models/book.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/pump_app.dart';

class MockBooksRepository extends Mock implements BooksRepository {}

class MockFavoritesCubit extends MockCubit<FavoritesState>
    implements FavoritesCubit {}

void main() {
  final List<Book> mockBooks = [
    Book(
      id: 0,
      title: 'title 0',
      author: 'author 0',
      description: 'description 0',
      image:
          'https://storage.googleapis.com/du-prd/books/images/9781501183058.jpg',
      publicationDate: DateTime(0),
    ),
    Book(
      id: 1,
      title: 'title 1',
      author: 'author 1',
      description: 'description 1',
      image:
          'https://storage.googleapis.com/du-prd/books/images/9781501183058.jpg',
      publicationDate: DateTime(1),
    ),
    Book(
      id: 2,
      title: 'title 2',
      author: 'author 2',
      description: 'description 2',
      image:
          'https://storage.googleapis.com/du-prd/books/images/9781501183058.jpg',
      publicationDate: DateTime(2),
    ),
  ];

  late FavoritesCubit favoritesCubit;

  setUpAll(() {
    HttpOverrides.global = null;
  });

  setUp(() async {
    favoritesCubit = MockFavoritesCubit();
  });

  group('FavoritesPage', () {
    late BooksRepository booksRepository;

    setUp(() {
      booksRepository = MockBooksRepository();
      when(() => booksRepository.fetchAllBooks()).thenAnswer((_) async {
        return mockBooks;
      });
    });

    testWidgets('renders FavoritesView', (tester) async {
      await tester.pumpApp(
        const FavoritesPage(),
        booksRepository: booksRepository,
      );

      await tester.pumpAndSettle();

      expect(find.byType(FavoritesView), findsOneWidget);
    });

    group('FavoritesView', () {
      setUp(() {
        when(() => favoritesCubit.state).thenReturn(const FavoritesState());
      });

      Widget buildSubject() {
        return BlocProvider<FavoritesCubit>.value(
          value: favoritesCubit,
          child: const FavoritesView(),
        );
      }

      testWidgets('renders results when bloc success', (tester) async {
        when(() => favoritesCubit.state).thenReturn(FavoritesState(
            status: FavoritesStatus.success, favorites: mockBooks));

        await tester.pumpApp(
          buildSubject(),
        );

        await tester.pumpAndSettle();

        expect(find.byType(BookPreview), findsExactly(3));
      });

      testWidgets('renders nothing when bloc success but no favorites',
          (tester) async {
        when(() => favoritesCubit.state).thenReturn(const FavoritesState(
            status: FavoritesStatus.success, favorites: []));

        await tester.pumpApp(
          buildSubject(),
        );

        await tester.pumpAndSettle();

        expect(find.byType(BookPreview), findsNothing);
      });

      testWidgets('renders error text when bloc emits error state',
          (tester) async {
        when(() => favoritesCubit.state)
            .thenReturn(const FavoritesState(status: FavoritesStatus.failure));

        await tester.pumpApp(
          buildSubject(),
        );

        await tester.pumpAndSettle();

        expect(find.text('Unknown error'), findsOne);
      });
    });
  });
}
