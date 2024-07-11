import 'package:alexandria/add_edit_book/bloc/abstract_bloc.dart';
import 'package:alexandria/add_edit_book/bloc/abstract_event.dart';
import 'package:alexandria/add_edit_book/bloc/abstract_state.dart';
import 'package:alexandria/all_books/all_books.dart';
import 'package:alexandria/books_repository.dart';
import 'package:alexandria/repository/models/book.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';

class EditBookBloc extends AbstractBloc {
  final Book book;

  EditBookBloc(
      AllBooksCubit allBooksCubit, BooksRepository booksRepository, this.book)
      : super(
            allBooksCubit,
            booksRepository,
            AbstractState(
              bookId: book.id,
              title: Text.dirty(book.title),
              author: Text.dirty(book.author),
              description: Text.dirty(book.description),
              image: Url.dirty(book.image),
              publicationDate: book.publicationDate,
            ));

  @override
  Future<void> onFormSubmitted(
      FormSubmitted event, Emitter<AbstractState> emit) async {
    assert(state.bookId != null);

    if (!state.isValid || state.publicationDate == null) return;
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

    try {
      await booksRepository.editBook(
        id: state.bookId!,
        title: state.title.value,
        author: state.author.value,
        description: state.description.value,
        image: state.image.value,
        publicationDate: state.publicationDate!.toIso8601String(),
      );

      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } catch (e) {
      emit(
        state.copyWith(
          status: FormzSubmissionStatus.failure,
          errorMessage: 'Error Occurred',
        ),
      );
    }
  }
}
