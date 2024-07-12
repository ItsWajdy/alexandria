import 'dart:io';

import 'package:alexandria/all_books/all_books.dart';
import 'package:alexandria/all_books/widgets/book_preview.dart';
import 'package:alexandria/all_books/widgets/new_book_card.dart';
import 'package:alexandria/repository/books_repository.dart';
import 'package:alexandria/repository/models/book.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/pump_app.dart';

class MockBooksRepository extends Mock implements BooksRepository {}

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

  late BooksRepository booksRepository;

  setUpAll(() {
    HttpOverrides.global = null;
  });

  setUp(() async {
    booksRepository = MockBooksRepository();

    when(() => booksRepository.fetchAllBooks()).thenAnswer((_) async {
      return mockBooks;
    });
  });

  group('AllBooksPage', () {
    testWidgets('renders GridView', (tester) async {
      await tester.pumpApp(
        const AllBooksPage(),
        booksRepository: booksRepository,
      );

      await tester.pumpAndSettle();

      expect(find.byType(GridView), findsOneWidget);
    });

    testWidgets('renders three books', (tester) async {
      await tester.pumpApp(
        const AllBooksPage(),
        booksRepository: booksRepository,
      );

      await tester.pumpAndSettle();

      expect(find.byType(BookPreview), findsExactly(3));
      expect(find.byType(NewBookCard), findsOneWidget);
    });

    testWidgets('renders AppBar', (tester) async {
      await tester.pumpApp(
        const AllBooksPage(),
        booksRepository: booksRepository,
      );

      expect(find.byType(AppBar), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(AppBar),
          matching: find.text('Alexandria'),
        ),
        findsOneWidget,
      );
    });

    testWidgets(
      'renders loading indicator when status is loading',
      (tester) async {
        when(() => booksRepository.fetchAllBooks()).thenAnswer((_) async {
          sleep(const Duration(seconds: 10));
          return mockBooks;
        });

        await tester.pumpApp(
          const AllBooksPage(),
          booksRepository: booksRepository,
        );

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      },
    );

    testWidgets('renders error text when status changes to failure',
        (tester) async {
      when(
        () => booksRepository.fetchAllBooks(),
      ).thenThrow(ApiServiceException);

      await tester.pumpApp(
        const AllBooksPage(),
        booksRepository: booksRepository,
      );

      expect(find.text('Unknown error.'), findsOne);
    });
  });
}
