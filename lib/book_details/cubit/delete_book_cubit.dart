import 'package:alexandria/all_books/cubit/all_books_cubit.dart';
import 'package:alexandria/repository/books_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'delete_book_state.dart';

class DeleteBookCubit extends Cubit<DeleteBookState> {
  DeleteBookCubit(this._allBooksCubit, this._booksRepository, this.bookId)
      : super(const DeleteBookState());

  final AllBooksCubit _allBooksCubit;
  final BooksRepository _booksRepository;
  final int bookId;

  Future<void> deleteBook() async {
    emit(state.copyWith(status: DeleteBookStatus.deleting));
    try {
      await _booksRepository.deleteBook(id: bookId);
      emit(state.copyWith(status: DeleteBookStatus.success));
    } on ApiServiceException catch (e) {
      emit(
        state.copyWith(
          status: DeleteBookStatus.failure,
          errorMessage: e.message,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: DeleteBookStatus.failure,
          errorMessage: 'Unknown error.',
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
