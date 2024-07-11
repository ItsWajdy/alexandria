import 'package:alexandria/repository/models/models.dart';
import 'package:equatable/equatable.dart';

enum FavoritesStatus { initial, loading, success, failure }

extension FavoritesStatusX on FavoritesStatus {
  bool get isInitial => this == FavoritesStatus.initial;
  bool get isLoading => this == FavoritesStatus.loading;
  bool get isSuccess => this == FavoritesStatus.success;
  bool get isFailure => this == FavoritesStatus.failure;
}

final class FavoritesState extends Equatable {
  final List<Book> favorites;
  final FavoritesStatus status;

  const FavoritesState({
    this.favorites = const [],
    this.status = FavoritesStatus.initial,
  });

  FavoritesState copyWith({
    List<Book>? favorites,
    FavoritesStatus? status,
  }) {
    return FavoritesState(
      favorites: favorites ?? this.favorites,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [favorites, status];
}
