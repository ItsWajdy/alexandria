import 'package:alexandria/add_edit_book/bloc/abstract_event.dart';
import 'package:alexandria/add_edit_book/bloc/abstract_state.dart';
import 'package:alexandria/add_edit_book/bloc/edit_book_bloc.dart';
import 'package:alexandria/all_books/all_books.dart';
import 'package:alexandria/repository/books_repository.dart';
import 'package:alexandria/repository/models/book.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';
import 'package:mocktail/mocktail.dart';

class MockBooksRepository extends Mock implements BooksRepository {}

class MockAllBooksCubit extends Mock implements AllBooksCubit {}

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

  group('EditBookBloc', () {
    late BooksRepository booksRepository;
    late AllBooksCubit allBooksCubit;

    setUp(() {
      booksRepository = MockBooksRepository();
      allBooksCubit = MockAllBooksCubit();

      when(
        () => booksRepository.editBook(
            id: any(named: 'id'),
            title: any(named: 'title'),
            author: any(named: 'author'),
            description: any(named: 'description'),
            image: any(named: 'image'),
            publicationDate: any(named: 'publicationDate')),
      ).thenAnswer((_) async {});

      when(() => allBooksCubit.fetchAllBooks()).thenAnswer((_) async {});
    });

    EditBookBloc buildBloc() {
      return EditBookBloc(allBooksCubit, booksRepository, mockBook);
    }

    group('constructor', () {
      test('works properly', () => expect(buildBloc, returnsNormally));

      test('has correct initial state', () {
        expect(
          buildBloc().state,
          equals(AbstractState(
            bookId: mockBook.id,
            title: Text.dirty(mockBook.title),
            author: Text.dirty(mockBook.author),
            description: Text.dirty(mockBook.description),
            image: Url.dirty(mockBook.image),
            publicationDate: mockBook.publicationDate,
          )),
        );
      });
    });

    group('TitleChanged', () {
      blocTest<EditBookBloc, AbstractState>(
        'emits valid when title is changed',
        build: buildBloc,
        seed: () => AbstractState(
          bookId: null,
          title: const Text.pure(),
          author: Text.dirty(mockBook.author),
          description: Text.dirty(mockBook.description),
          image: Url.dirty(mockBook.image),
          publicationDate: mockBook.publicationDate,
          status: FormzSubmissionStatus.initial,
          isValid: false,
          errorMessage: null,
        ),
        act: (bloc) => bloc.add(const TitleChanged(text: 'new title')),
        expect: () => [
          AbstractState(
            bookId: null,
            title: const Text.dirty('new title'),
            author: Text.dirty(mockBook.author),
            description: Text.dirty(mockBook.description),
            image: Url.dirty(mockBook.image),
            publicationDate: mockBook.publicationDate,
            status: FormzSubmissionStatus.initial,
            isValid: true,
            errorMessage: null,
          ),
        ],
      );

      blocTest<EditBookBloc, AbstractState>(
        'emits invalid when title is empty',
        build: buildBloc,
        seed: () => AbstractState(
          bookId: null,
          title: const Text.pure(),
          author: Text.dirty(mockBook.author),
          description: Text.dirty(mockBook.description),
          image: Url.dirty(mockBook.image),
          publicationDate: mockBook.publicationDate,
          status: FormzSubmissionStatus.initial,
          isValid: false,
          errorMessage: null,
        ),
        act: (bloc) => bloc.add(const TitleChanged(text: '')),
        expect: () => [
          AbstractState(
            bookId: null,
            title: const Text.dirty(''),
            author: Text.dirty(mockBook.author),
            description: Text.dirty(mockBook.description),
            image: Url.dirty(mockBook.image),
            publicationDate: mockBook.publicationDate,
            status: FormzSubmissionStatus.initial,
            isValid: false,
            errorMessage: null,
          ),
        ],
      );
    });

    group('AuthorChanged', () {
      blocTest<EditBookBloc, AbstractState>(
        'emits valid when author is changed',
        build: buildBloc,
        seed: () => AbstractState(
          bookId: null,
          title: Text.dirty(mockBook.title),
          author: const Text.pure(),
          description: Text.dirty(mockBook.description),
          image: Url.dirty(mockBook.image),
          publicationDate: mockBook.publicationDate,
          status: FormzSubmissionStatus.initial,
          isValid: false,
          errorMessage: null,
        ),
        act: (bloc) => bloc.add(const AuthorChanged(text: 'new author')),
        expect: () => [
          AbstractState(
            bookId: null,
            title: Text.dirty(mockBook.title),
            author: const Text.dirty('new author'),
            description: Text.dirty(mockBook.description),
            image: Url.dirty(mockBook.image),
            publicationDate: mockBook.publicationDate,
            status: FormzSubmissionStatus.initial,
            isValid: true,
            errorMessage: null,
          ),
        ],
      );

      blocTest<EditBookBloc, AbstractState>(
        'emits invalid when author is empty',
        build: buildBloc,
        seed: () => AbstractState(
          bookId: null,
          title: Text.dirty(mockBook.title),
          author: const Text.pure(),
          description: Text.dirty(mockBook.description),
          image: Url.dirty(mockBook.image),
          publicationDate: mockBook.publicationDate,
          status: FormzSubmissionStatus.initial,
          isValid: false,
          errorMessage: null,
        ),
        act: (bloc) => bloc.add(const AuthorChanged(text: '')),
        expect: () => [
          AbstractState(
            bookId: null,
            title: Text.dirty(mockBook.title),
            author: const Text.dirty(''),
            description: Text.dirty(mockBook.description),
            image: Url.dirty(mockBook.image),
            publicationDate: mockBook.publicationDate,
            status: FormzSubmissionStatus.initial,
            isValid: false,
            errorMessage: null,
          ),
        ],
      );
    });

    group('DescriptionChanged', () {
      blocTest<EditBookBloc, AbstractState>(
        'emits valid when description is changed',
        build: buildBloc,
        seed: () => AbstractState(
          bookId: null,
          title: Text.dirty(mockBook.title),
          author: Text.dirty(mockBook.author),
          description: const Text.pure(),
          image: Url.dirty(mockBook.image),
          publicationDate: mockBook.publicationDate,
          status: FormzSubmissionStatus.initial,
          isValid: false,
          errorMessage: null,
        ),
        act: (bloc) =>
            bloc.add(const DescriptionChanged(text: 'new description')),
        expect: () => [
          AbstractState(
            bookId: null,
            title: Text.dirty(mockBook.title),
            author: Text.dirty(mockBook.author),
            description: const Text.dirty('new description'),
            image: Url.dirty(mockBook.image),
            publicationDate: mockBook.publicationDate,
            status: FormzSubmissionStatus.initial,
            isValid: true,
            errorMessage: null,
          ),
        ],
      );

      blocTest<EditBookBloc, AbstractState>(
        'emits invalid when description is empty',
        build: buildBloc,
        seed: () => AbstractState(
          bookId: null,
          title: Text.dirty(mockBook.title),
          author: Text.dirty(mockBook.author),
          description: const Text.pure(),
          image: Url.dirty(mockBook.image),
          publicationDate: mockBook.publicationDate,
          status: FormzSubmissionStatus.initial,
          isValid: false,
          errorMessage: null,
        ),
        act: (bloc) => bloc.add(const DescriptionChanged(text: '')),
        expect: () => [
          AbstractState(
            bookId: null,
            title: Text.dirty(mockBook.title),
            author: Text.dirty(mockBook.author),
            description: const Text.dirty(''),
            image: Url.dirty(mockBook.image),
            publicationDate: mockBook.publicationDate,
            status: FormzSubmissionStatus.initial,
            isValid: false,
            errorMessage: null,
          ),
        ],
      );
    });

    group('ImageChanged', () {
      blocTest<EditBookBloc, AbstractState>(
        'emits valid when image is changed',
        build: buildBloc,
        seed: () => AbstractState(
          bookId: null,
          title: Text.dirty(mockBook.title),
          author: Text.dirty(mockBook.author),
          description: Text.dirty(mockBook.description),
          image: const Url.pure(),
          publicationDate: mockBook.publicationDate,
          status: FormzSubmissionStatus.initial,
          isValid: false,
          errorMessage: null,
        ),
        act: (bloc) => bloc.add(const ImageChanged(text: 'https://.jpg')),
        expect: () => [
          AbstractState(
            bookId: null,
            title: Text.dirty(mockBook.title),
            author: Text.dirty(mockBook.author),
            description: Text.dirty(mockBook.description),
            image: const Url.dirty('https://.jpg'),
            publicationDate: mockBook.publicationDate,
            status: FormzSubmissionStatus.initial,
            isValid: true,
            errorMessage: null,
          ),
        ],
      );

      blocTest<EditBookBloc, AbstractState>(
        'emits invalid when image is invalid',
        build: buildBloc,
        seed: () => AbstractState(
          bookId: null,
          title: Text.dirty(mockBook.title),
          author: Text.dirty(mockBook.author),
          description: Text.dirty(mockBook.description),
          image: const Url.pure(),
          publicationDate: mockBook.publicationDate,
          status: FormzSubmissionStatus.initial,
          isValid: false,
          errorMessage: null,
        ),
        act: (bloc) => bloc.add(const ImageChanged(text: 'a random text')),
        expect: () => [
          AbstractState(
            bookId: null,
            title: Text.dirty(mockBook.title),
            author: Text.dirty(mockBook.author),
            description: Text.dirty(mockBook.description),
            image: const Url.dirty('a random text'),
            publicationDate: mockBook.publicationDate,
            status: FormzSubmissionStatus.initial,
            isValid: false,
            errorMessage: null,
          ),
        ],
      );
    });

    group('FormSubmitted', () {
      blocTest<EditBookBloc, AbstractState>(
        'calls the editBook method in repository',
        build: buildBloc,
        seed: () => AbstractState(
          bookId: mockBook.id,
          title: Text.dirty(mockBook.title),
          author: Text.dirty(mockBook.author),
          description: Text.dirty(mockBook.description),
          image: Url.dirty(mockBook.image),
          publicationDate: mockBook.publicationDate,
          status: FormzSubmissionStatus.initial,
          isValid: true,
          errorMessage: null,
        ),
        act: (bloc) => bloc.add(FormSubmitted()),
        verify: (_) {
          verify(() => booksRepository.editBook(
              id: any(named: 'id'),
              title: any(named: 'title'),
              author: any(named: 'author'),
              description: any(named: 'description'),
              image: any(named: 'image'),
              publicationDate: any(named: 'publicationDate'))).called(1);
        },
      );

      blocTest<EditBookBloc, AbstractState>(
        'emits state with success status',
        build: buildBloc,
        seed: () => AbstractState(
          bookId: mockBook.id,
          title: Text.dirty(mockBook.title),
          author: Text.dirty(mockBook.author),
          description: Text.dirty(mockBook.description),
          image: Url.dirty(mockBook.image),
          publicationDate: mockBook.publicationDate,
          status: FormzSubmissionStatus.initial,
          isValid: true,
          errorMessage: null,
        ),
        act: (bloc) => bloc.add(FormSubmitted()),
        expect: () => [
          AbstractState(
            bookId: mockBook.id,
            title: Text.dirty(mockBook.title),
            author: Text.dirty(mockBook.author),
            description: Text.dirty(mockBook.description),
            image: Url.dirty(mockBook.image),
            publicationDate: mockBook.publicationDate,
            status: FormzSubmissionStatus.inProgress,
            isValid: true,
            errorMessage: null,
          ),
          AbstractState(
            bookId: mockBook.id,
            title: Text.dirty(mockBook.title),
            author: Text.dirty(mockBook.author),
            description: Text.dirty(mockBook.description),
            image: Url.dirty(mockBook.image),
            publicationDate: mockBook.publicationDate,
            status: FormzSubmissionStatus.success,
            isValid: true,
            errorMessage: null,
          ),
        ],
      );

      blocTest<EditBookBloc, AbstractState>(
        'emits state with failure status when repository throws error',
        setUp: () {
          when(
            () => booksRepository.editBook(
                id: any(named: 'id'),
                title: any(named: 'title'),
                author: any(named: 'author'),
                description: any(named: 'description'),
                image: any(named: 'image'),
                publicationDate: any(named: 'publicationDate')),
          ).thenThrow(ApiServiceException);
        },
        build: buildBloc,
        seed: () => AbstractState(
          bookId: mockBook.id,
          title: Text.dirty(mockBook.title),
          author: Text.dirty(mockBook.author),
          description: Text.dirty(mockBook.description),
          image: Url.dirty(mockBook.image),
          publicationDate: mockBook.publicationDate,
          status: FormzSubmissionStatus.initial,
          isValid: true,
          errorMessage: null,
        ),
        act: (bloc) => bloc.add(FormSubmitted()),
        expect: () => [
          AbstractState(
            bookId: mockBook.id,
            title: Text.dirty(mockBook.title),
            author: Text.dirty(mockBook.author),
            description: Text.dirty(mockBook.description),
            image: Url.dirty(mockBook.image),
            publicationDate: mockBook.publicationDate,
            status: FormzSubmissionStatus.inProgress,
            isValid: true,
            errorMessage: null,
          ),
          AbstractState(
            bookId: mockBook.id,
            title: Text.dirty(mockBook.title),
            author: Text.dirty(mockBook.author),
            description: Text.dirty(mockBook.description),
            image: Url.dirty(mockBook.image),
            publicationDate: mockBook.publicationDate,
            status: FormzSubmissionStatus.failure,
            isValid: true,
            errorMessage: 'Unknown error.',
          ),
        ],
      );
    });
  });
}
