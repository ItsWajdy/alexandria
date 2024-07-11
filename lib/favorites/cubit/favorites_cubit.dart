import 'package:alexandria/favorites/cubit/favorites_state.dart';
import 'package:alexandria/favorites/repository/favorites_repository.dart';
import 'package:alexandria/repository/models/book.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// TODO rethink entire concept and refactor this Cubit
class FavoritesCubit extends Cubit<FavoritesState> {
  final FavoritesRepository _favoritesRepository;

  FavoritesCubit(this._favoritesRepository) : super(const FavoritesState());

  Future<bool> flipFavoriteStatus(int id) async {
    try {
      if (isBookInFavorites(id)) {
        await _favoritesRepository.removeIdFromFavorites(id);
      } else {
        await _favoritesRepository.addIdToFavorites(id);
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  bool isBookInFavorites(int id) {
    try {
      List<int> favoritesIds = _favoritesRepository.getFavoritesIds();
      return favoritesIds.contains(id);
    } catch (e) {
      rethrow;
    }
  }

  void getFavoritesFrom(List<Book> allBooks) {
    emit(state.copyWith(status: FavoritesStatus.loading));

    try {
      List<int> favoritesIds = _favoritesRepository.getFavoritesIds();
      List<Book> favorites =
          allBooks.where((e) => favoritesIds.contains(e.id)).toList();

      emit(state.copyWith(
          favorites: favorites, status: FavoritesStatus.success));
    } catch (e) {
      emit(state.copyWith(status: FavoritesStatus.failure));
    }
  }
}
