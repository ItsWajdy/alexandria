import 'package:alexandria/favorites/favorites_cubit/favorites_state.dart';
import 'package:alexandria/favorites/repository/favorites_repository.dart';
import 'package:alexandria/repository/models/book.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final FavoritesRepository _favoritesRepository;

  FavoritesCubit(this._favoritesRepository) : super(const FavoritesState());

  void getFavoritesFrom(List<Book> allBooks) {
    emit(state.copyWith(status: FavoritesStatus.loading));

    try {
      List<int> favoritesIds = _favoritesRepository.getFavoritesIds();
      List<Book> favorites =
          allBooks.where((e) => favoritesIds.contains(e.id)).toList();

      emit(state.copyWith(
          favorites: favorites, status: FavoritesStatus.success));
    } on HiveNotInitializedException {
      emit(
        state.copyWith(
          status: FavoritesStatus.failure,
          errorMessage: 'This should NOT happen',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: FavoritesStatus.failure,
          errorMessage: 'Unknown error',
        ),
      );
    }
  }
}
