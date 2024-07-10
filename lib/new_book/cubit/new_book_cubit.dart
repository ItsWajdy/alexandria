import 'package:alexandria/books_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';

part 'new_book_state.dart';

class NewBookCubit extends Cubit<NewBookState> {
  final BooksRepository _booksRepository;

  NewBookCubit(this._booksRepository) : super(const NewBookState());

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
      await _booksRepository.addNewBook(
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
