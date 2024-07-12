import 'dart:io';

import 'package:alexandria/ui/widgets/book_preview.dart';
import 'package:alexandria/repository/books_repository.dart';
import 'package:alexandria/repository/models/book.dart';
import 'package:alexandria/search/bloc/search_event.dart';
import 'package:alexandria/search/bloc/search_state.dart';
import 'package:alexandria/search/search.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/pump_app.dart';

class MockBooksRepository extends Mock implements BooksRepository {}

class MockSearchBloc extends MockBloc<SearchEvent, SearchState>
    implements SearchBloc {}

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

  late SearchBloc searchBloc;

  setUpAll(() {
    HttpOverrides.global = null;
  });

  setUp(() async {
    searchBloc = MockSearchBloc();
  });

  group('SearchPage', () {
    late BooksRepository booksRepository;

    setUp(() {
      booksRepository = MockBooksRepository();
      when(() => booksRepository.fetchAllBooks()).thenAnswer((_) async {
        return mockBooks;
      });
    });

    testWidgets('renders SearchView', (tester) async {
      await tester.pumpApp(
        const SearchPage(),
        booksRepository: booksRepository,
      );

      await tester.pumpAndSettle();

      expect(find.byType(SearchView), findsOneWidget);
    });
  });

  group('SearchView', () {
    setUp(() {
      when(() => searchBloc.state).thenReturn(const SearchState());
    });

    Widget buildSubject() {
      return BlocProvider<SearchBloc>.value(
        value: searchBloc,
        child: const SearchView(),
      );
    }

    testWidgets('renders results when bloc success', (tester) async {
      when(() => searchBloc.state).thenReturn(
          SearchState(status: SearchStatus.success, results: mockBooks));
      await tester.pumpApp(
        buildSubject(),
      );

      await tester.pumpAndSettle();

      expect(find.byType(BookPreview), findsExactly(3));
    });

    testWidgets('renders error text when bloc returns empty results',
        (tester) async {
      when(() => searchBloc.state)
          .thenReturn(const SearchState(status: SearchStatus.noResults));
      await tester.pumpApp(
        buildSubject(),
      );

      await tester.pumpAndSettle();

      expect(find.text('No Results'), findsOne);
    });
  });
}
