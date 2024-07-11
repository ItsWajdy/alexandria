import 'package:alexandria/add_edit_book/bloc/abstract_event.dart';
import 'package:alexandria/add_edit_book/bloc/abstract_state.dart';
import 'package:alexandria/books_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';

abstract class AbstractBloc extends Bloc<AbstractEvent, AbstractState> {
  final BooksRepository booksRepository;
  final AbstractState initialState;

  AbstractBloc(this.booksRepository, this.initialState) : super(initialState) {
    on<TitleChanged>(_onTitleChanged);
    on<AuthorChanged>(_onAuthorChanged);
    on<DescriptionChanged>(_onDescriptionChanged);
    on<ImageChanged>(_onImageChanged);
    on<PublicationDateChanged>(_onPublicationDateChanged);
    on<FormSubmitted>(onFormSubmitted);
  }

  void _onTitleChanged(TitleChanged event, Emitter<AbstractState> emit) {
    final Text title = Text.dirty(event.text);
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

  void _onAuthorChanged(AuthorChanged event, Emitter<AbstractState> emit) {
    final Text author = Text.dirty(event.text);
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

  void _onDescriptionChanged(
      DescriptionChanged event, Emitter<AbstractState> emit) {
    final Text description = Text.dirty(event.text);
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

  void _onImageChanged(ImageChanged event, Emitter<AbstractState> emit) {
    final Url image = Url.dirty(event.text);
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

  void _onPublicationDateChanged(
      PublicationDateChanged event, Emitter<AbstractState> emit) {
    emit(
      state.copyWith(
          publicationDate: event.date,
          isValid: Formz.validate([
            state.title,
            state.author,
            state.description,
            state.image,
          ])),
    );
  }

  Future<void> onFormSubmitted(
      FormSubmitted event, Emitter<AbstractState> emit);
  // if (!state.isValid || state.publicationDate == null) return;
  // emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
  // try {
  //   await _booksRepository.editBook(
  //     id: state.bookId,
  //     title: state.title.value,
  //     author: state.author.value,
  //     description: state.description.value,
  //     image: state.image.value,
  //     publicationDate: state.publicationDate!.toIso8601String(),
  //   );
  //
  //   emit(state.copyWith(status: FormzSubmissionStatus.success));
  // } catch (e) {
  //   emit(
  //     state.copyWith(
  //       status: FormzSubmissionStatus.failure,
  //       errorMessage: 'Error Occurred',
  //     ),
  //   );
  // }
}
