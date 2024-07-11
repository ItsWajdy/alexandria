import 'package:alexandria/add_edit_book/bloc/abstract_bloc.dart';
import 'package:alexandria/add_edit_book/bloc/abstract_event.dart';
import 'package:alexandria/add_edit_book/bloc/abstract_state.dart';
import 'package:alexandria/all_books/all_books.dart';
import 'package:alexandria/repository/books_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class AddBookBloc extends AbstractBloc {
  AddBookBloc(AllBooksCubit allBooksCubit, BooksRepository booksRepository)
      : super(allBooksCubit, booksRepository, const AbstractState());

  @override
  Future<void> onFormSubmitted(
      FormSubmitted event, Emitter<AbstractState> emit) async {
    assert(state.bookId == null);

    if (!state.isValid || state.publicationDate == null) return;
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

    try {
      await booksRepository.addNewBook(
        title: state.title.value,
        author: state.author.value,
        description: state.description.value,
        image: state.image.value,
        publicationDate: state.publicationDate!.toIso8601String(),
      );

      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } on ApiServiceException catch (e) {
      emit(
        state.copyWith(
          status: FormzSubmissionStatus.failure,
          errorMessage: e.message,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: FormzSubmissionStatus.failure,
          errorMessage: 'Unknown error.',
        ),
      );
    }
  }
}
