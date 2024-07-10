import 'package:alexandria/books_repository.dart';
import 'package:alexandria/repository/models/book.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';

part 'edit_book_state.dart';

class EditBookCubit extends Cubit<EditBookState> {
  final BooksRepository _booksRepository;
  final Book book;

  EditBookCubit(this._booksRepository, this.book)
      : super(
          EditBookState(
            bookId: book.id,
            title: Text.dirty(book.title),
            author: Text.dirty(book.author),
            description: Text.dirty(book.description),
            image: Url.dirty(book.image),
            publicationDate: book.publicationDate,
          ),
        );

  void titleChanged(String value) {
    final Text title = Text.dirty(value);
    emit(
      state.copyWith(
        title: title,
        isValid: Formz.validate([
              title,
              state.author,
              state.description,
              state.image,
            ]) &&
            state.publicationDate != null,
      ),
    );
  }

  void authorChanged(String value) {
    final Text author = Text.dirty(value);
    emit(
      state.copyWith(
        author: author,
        isValid: Formz.validate([
              state.title,
              author,
              state.description,
              state.image,
            ]) &&
            state.publicationDate != null,
      ),
    );
  }

  void descriptionChanged(String value) {
    final Text description = Text.dirty(value);
    emit(
      state.copyWith(
        description: description,
        isValid: Formz.validate([
              state.title,
              state.author,
              description,
              state.image,
            ]) &&
            state.publicationDate != null,
      ),
    );
  }

  void imageChanged(String value) {
    final Url image = Url.dirty(value);
    emit(
      state.copyWith(
        image: image,
        isValid: Formz.validate([
              state.title,
              state.author,
              state.description,
              image,
            ]) &&
            state.publicationDate != null,
      ),
    );
  }

  void publicationDateChanged(DateTime value) {
    emit(
      state.copyWith(
          publicationDate: value,
          isValid: Formz.validate([
            state.title,
            state.author,
            state.description,
            state.image,
          ])),
    );
  }

  Future<void> saveNewBook() async {
    if (!state.isValid || state.publicationDate == null) return;
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      await _booksRepository.editBook(
        id: state.bookId,
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
