import 'package:alexandria/repository/models/book.dart';
import 'package:alexandria/search/bloc/search_bloc.dart';
import 'package:alexandria/search/bloc/search_event.dart';
import 'package:alexandria/search/bloc/search_state.dart';
import 'package:alexandria/search/search.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

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

  group('SearchBloc', () {
    SearchBloc buildBloc() {
      return SearchBloc(mockBooks);
    }

    group('constructor', () {
      test('works properly', () => expect(buildBloc, returnsNormally));

      test('has correct initial state', () {
        expect(
          buildBloc().state,
          equals(const SearchState()),
        );
      });
    });

    group('SearchQueryChanged', () {
      blocTest<SearchBloc, SearchState>(
        'emits success when query in books',
        build: buildBloc,
        act: (bloc) => bloc.add(const SearchQueryChanged(query: 'title 0')),
        expect: () => [
          const SearchState(status: SearchStatus.searching),
          SearchState(status: SearchStatus.success, results: [mockBooks[0]]),
        ],
      );

      blocTest<SearchBloc, SearchState>(
        'emits success when query in books and different case',
        build: buildBloc,
        act: (bloc) => bloc.add(const SearchQueryChanged(query: 'TITLE 0')),
        expect: () => [
          const SearchState(status: SearchStatus.searching),
          SearchState(status: SearchStatus.success, results: [mockBooks[0]]),
        ],
      );

      blocTest<SearchBloc, SearchState>(
        'emits no results when query not in books',
        build: buildBloc,
        act: (bloc) => bloc.add(const SearchQueryChanged(query: 'title 10')),
        expect: () => [
          const SearchState(status: SearchStatus.searching),
          const SearchState(status: SearchStatus.noResults, results: []),
        ],
      );

      blocTest<SearchBloc, SearchState>(
        'emits no results when query is empty',
        build: buildBloc,
        act: (bloc) => bloc.add(const SearchQueryChanged(query: '')),
        expect: () => [
          const SearchState(status: SearchStatus.searching),
          const SearchState(status: SearchStatus.noResults, results: []),
        ],
      );
    });
  });
}
