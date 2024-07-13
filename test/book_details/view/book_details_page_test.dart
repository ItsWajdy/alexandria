import 'dart:io';

import 'package:alexandria/book_details/book_details.dart';
import 'package:alexandria/book_details/cubit/delete_book_cubit.dart';
import 'package:alexandria/favorites/edit_favorites_cubit/edit_favorites_cubit.dart';
import 'package:alexandria/favorites/repository/favorites_repository.dart';
import 'package:alexandria/repository/books_repository.dart';
import 'package:alexandria/repository/models/book.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/pump_app.dart';

class MockBooksRepository extends Mock implements BooksRepository {}

class MockFavoritesRepository extends Mock implements FavoritesRepository {}

class MockDeleteBookCubit extends MockCubit<DeleteBookState>
    implements DeleteBookCubit {}

class MockEditFavoritesCubit extends MockCubit<EditFavoritesState>
    implements EditFavoritesCubit {}

void main() {
  final Book mockBook = Book(
    id: 0,
    title: 'title 0',
    author: 'author 0',
    description: 'description 0',
    image:
        'https://storage.googleapis.com/du-prd/books/images/9781501183058.jpg',
    publicationDate: DateTime(0),
  );

  setUpAll(() async {
    HttpOverrides.global = null;
  });

  group('BookDetailsPage', () {
    late BooksRepository booksRepository;
    late FavoritesRepository favoritesRepository;

    setUp(() {
      booksRepository = MockBooksRepository();
      favoritesRepository = MockFavoritesRepository();

      when(() => favoritesRepository.isBookInFavorites(any()))
          .thenAnswer((_) => false);
    });

    testWidgets('renders BookDetailsView', (tester) async {
      await tester.pumpApp(
        BookDetailsPage(book: mockBook),
        booksRepository: booksRepository,
        favoritesRepository: favoritesRepository,
      );

      expect(find.byType(BookDetailsView), findsOneWidget);
    });
  });

  group('BookDetailsView', () {
    late DeleteBookCubit deleteBookCubit;
    late EditFavoritesCubit editFavoritesCubit;

    setUp(() {
      deleteBookCubit = MockDeleteBookCubit();
      editFavoritesCubit = MockEditFavoritesCubit();

      when(() => deleteBookCubit.state).thenReturn(const DeleteBookState());

      when(() => editFavoritesCubit.state)
          .thenReturn(const EditFavoritesState());
    });

    Widget buildSubject() {
      return MultiBlocProvider(
        providers: [
          BlocProvider.value(value: deleteBookCubit),
          BlocProvider.value(value: editFavoritesCubit),
        ],
        child: BookDetailsView(book: mockBook),
      );
    }

    testWidgets(
      'renders error snackbar when status changes to failure',
      (tester) async {
        whenListen<DeleteBookState>(
          deleteBookCubit,
          Stream.fromIterable([
            const DeleteBookState(
              status: DeleteBookStatus.failure,
              errorMessage: 'ERROR',
            ),
          ]),
        );

        await tester.pumpApp(
          buildSubject(),
        );
        await tester.pumpAndSettle();

        expect(find.byType(SnackBar), findsOneWidget);
        expect(
          find.descendant(
            of: find.byType(SnackBar),
            matching: find.text('ERROR'),
          ),
          findsOneWidget,
        );
      },
    );
  });
}
