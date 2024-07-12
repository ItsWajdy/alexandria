import 'package:alexandria/all_books/all_books.dart';
import 'package:alexandria/book_details/cubit/delete_book_cubit.dart';
import 'package:alexandria/repository/books_repository.dart';
import 'package:alexandria/repository/models/book.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockBooksRepository extends Mock implements BooksRepository {}

class MockAllBooksCubit extends Mock implements AllBooksCubit {}

class FakeBook extends Fake implements Book {}

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

  group('BookDetailsCubit', () {
    late BooksRepository booksRepository;
    late AllBooksCubit allBooksCubit;

    setUpAll(() {
      registerFallbackValue(FakeBook());
    });

    setUp(() {
      booksRepository = MockBooksRepository();
      allBooksCubit = MockAllBooksCubit();

      when(() => booksRepository.fetchBookDetails(id: any(named: 'id')))
          .thenAnswer((_) async {
        return mockBook;
      });
      when(() => booksRepository.deleteBook(id: any(named: 'id')))
          .thenAnswer((_) async {});
      when(() => allBooksCubit.fetchAllBooks()).thenAnswer((_) async {});
    });

    DeleteBookCubit buildBloc() {
      return DeleteBookCubit(allBooksCubit, booksRepository, mockBook.id);
    }

    group('constructor', () {
      test('works properly', () => expect(buildBloc, returnsNormally));

      test('has correct initial state', () {
        expect(
          buildBloc().state,
          equals(const DeleteBookState()),
        );
      });
    });

    group('deleteBook', () {
      blocTest<DeleteBookCubit, DeleteBookState>(
          'emits state with success status when repository deleteBook is called',
          build: buildBloc,
          act: (bloc) => bloc.deleteBook(),
          expect: () => [
                const DeleteBookState(
                  status: DeleteBookStatus.deleting,
                ),
                const DeleteBookState(
                  status: DeleteBookStatus.success,
                ),
              ]);
    });

    blocTest<DeleteBookCubit, DeleteBookState>(
        'emits state with failure status when repository deleteBook emits error',
        setUp: () {
          when(
            () => booksRepository.deleteBook(id: any(named: 'id')),
          ).thenThrow(ApiServiceException);
        },
        build: buildBloc,
        act: (bloc) => bloc.deleteBook(),
        expect: () => [
              const DeleteBookState(status: DeleteBookStatus.deleting),
              const DeleteBookState(
                  status: DeleteBookStatus.failure,
                  errorMessage: 'Unknown error.'),
            ]);
  });
}
