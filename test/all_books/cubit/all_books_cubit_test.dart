import 'package:alexandria/all_books/all_books.dart';
import 'package:alexandria/repository/books_repository.dart';
import 'package:alexandria/repository/models/book.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockBooksRepository extends Mock implements BooksRepository {}

class FakeBook extends Fake implements Book {}

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

  group('AllBooksCubit', () {
    late BooksRepository booksRepository;

    setUpAll(() {
      registerFallbackValue(FakeBook());
    });

    setUp(() {
      booksRepository = MockBooksRepository();
      when(
        () => booksRepository.fetchAllBooks(),
      ).thenAnswer((_) async {
        return mockBooks;
      });
    });

    AllBooksCubit buildBloc() {
      return AllBooksCubit(booksRepository);
    }

    group('constructor', () {
      test('works properly', () => expect(buildBloc, returnsNormally));

      test('has correct initial state', () {
        expect(
          buildBloc().state,
          equals(const AllBooksState()),
        );
      });
    });

    group('fetchAllBooks', () {
      blocTest<AllBooksCubit, AllBooksState>(
          'emits state with success status when repository fetchAllBooks is called',
          build: buildBloc,
          act: (bloc) => bloc.fetchAllBooks(),
          expect: () => [
                const AllBooksState(
                  status: AllBooksStatus.loading,
                ),
                AllBooksState(
                  status: AllBooksStatus.success,
                  allBooks: mockBooks,
                ),
              ]);

      blocTest<AllBooksCubit, AllBooksState>(
          'emits state with failure status when repository fetchAllBooks emits error',
          setUp: () {
            when(
              () => booksRepository.fetchAllBooks(),
            ).thenThrow(ApiServiceException);
          },
          build: buildBloc,
          act: (bloc) => bloc.fetchAllBooks(),
          expect: () => [
                const AllBooksState(status: AllBooksStatus.loading),
                const AllBooksState(
                    status: AllBooksStatus.failure,
                    errorMessage: 'Unknown error.'),
              ]);
    });
  });
}
