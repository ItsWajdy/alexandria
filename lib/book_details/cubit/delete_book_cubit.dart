import 'package:alexandria/all_books/cubit/all_books_cubit.dart';
import 'package:alexandria/books_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'delete_book_state.dart';

class DeleteBookCubit extends Cubit<DeleteBookState> {
  final AllBooksCubit _allBooksCubit;

  DeleteBookCubit(this._allBooksCubit, this._booksRepository, this.bookId)
      : super(DeleteBookState(bookId: bookId));

  final BooksRepository _booksRepository;
  final int bookId;

  Future<void> deleteBook() async {
    emit(state.copyWith(status: DeleteBookStatus.deleting));
    try {
      await _booksRepository.deleteBook(id: state.bookId);
      emit(state.copyWith(status: DeleteBookStatus.success));
    } catch (e) {
      emit(
        state.copyWith(
          status: DeleteBookStatus.failure,
          errorMessage: 'Error Occurred',
        ),
      );
    }
  }

  @override
  void onChange(Change<DeleteBookState> change) {
    super.onChange(change);

    if (change.nextState.status.isSuccess) {
      // TODO maybe there is a better way of notify AllBooksCubit of data change
      _allBooksCubit.fetchAllBooks();
    }
  }
}
