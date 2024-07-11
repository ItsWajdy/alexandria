part of 'edit_favorites_cubit.dart';

final class EditFavoritesState extends Equatable {
  final bool isBookInFavorites;
  final bool success;
  final String? errorMessage;

  const EditFavoritesState({
    this.isBookInFavorites = false,
    this.success = false,
    this.errorMessage,
  });

  EditFavoritesState copyWith({
    bool? isBookInFavorites,
    bool? success,
    String? errorMessage,
  }) {
    return EditFavoritesState(
      isBookInFavorites: isBookInFavorites ?? this.isBookInFavorites,
      success: success ?? this.success,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        isBookInFavorites,
        success,
        errorMessage,
      ];
}
