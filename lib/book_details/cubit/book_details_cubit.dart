import 'package:alexandria/books_repository.dart';
import 'package:alexandria/repository/models/models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'book_details_state.dart';

class BookDetailsCubit extends Cubit<BookDetailsState> {
  BookDetailsCubit(this._booksRepository) : super(const BookDetailsState());

  final BooksRepository _booksRepository;

  Future<void> fetchBookDetails(int id) async {
    emit(state.copyWith(status: BookDetailsStatus.loading));

    try {
      final Book bookDetails = await _booksRepository.fetchBookDetails(id);

      emit(
        state.copyWith(
          status: BookDetailsStatus.success,
          bookDetails: bookDetails,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: BookDetailsStatus.failure));
    }
  }
}
