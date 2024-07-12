import 'package:alexandria/favorites/repository/favorites_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'edit_favorites_state.dart';

class EditFavoritesCubit extends Cubit<EditFavoritesState> {
  final FavoritesRepository _favoritesRepository;
  final int bookId;

  EditFavoritesCubit(this._favoritesRepository, this.bookId)
      : super(const EditFavoritesState()) {
    isBookInFavorites();
  }

  Future<void> flipFavoriteStatus() async {
    try {
      if (_favoritesRepository.isBookInFavorites(bookId)) {
        await _favoritesRepository.removeIdFromFavorites(bookId);
        emit(state.copyWith(success: true, isBookInFavorites: false));
      } else {
        await _favoritesRepository.addIdToFavorites(bookId);
        emit(state.copyWith(success: true, isBookInFavorites: true));
      }
    } on HiveNotInitializedException {
      emit(
        state.copyWith(
          success: false,
          errorMessage: 'This should NOT happen',
        ),
      );
    } on BookAlreadyInFavorites {
      emit(
        state.copyWith(
          success: false,
          errorMessage: 'This book is already in favorites',
        ),
      );
    } on BookNotInFavorites {
      emit(
        state.copyWith(
          success: false,
          errorMessage: 'This book does not exist in favorites',
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          success: false,
          errorMessage: 'Unknown error',
        ),
      );
    }
  }

  void isBookInFavorites() {
    try {
      emit(state.copyWith(
          isBookInFavorites: _favoritesRepository.isBookInFavorites(bookId)));
    } on HiveNotInitializedException {
      emit(
        state.copyWith(
          success: false,
          errorMessage: 'This should NOT happen',
        ),
      );
    } catch (e) {
      rethrow;
    }
  }
}
