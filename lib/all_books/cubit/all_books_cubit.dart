import 'package:alexandria/repository/books_repository.dart';
import 'package:alexandria/repository/models/models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'all_books_state.dart';

class AllBooksCubit extends Cubit<AllBooksState> {
  AllBooksCubit(this._booksRepository) : super(const AllBooksState());

  final BooksRepository _booksRepository;

  Future<void> fetchAllBooks() async {
    emit(state.copyWith(status: AllBooksStatus.loading));

    try {
      final List<Book> allBooks = await _booksRepository.fetchAllBooks();

      emit(
        state.copyWith(
          status: AllBooksStatus.success,
          allBooks: allBooks,
        ),
      );
    } on ApiServiceException catch (e) {
      emit(
        state.copyWith(
          status: AllBooksStatus.failure,
          errorMessage: e.message,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AllBooksStatus.failure,
          errorMessage: 'Unknown error.',
        ),
      );
    }
  }
}
