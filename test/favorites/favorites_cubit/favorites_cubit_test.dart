import 'package:alexandria/favorites/favorites.dart';
import 'package:alexandria/favorites/favorites_cubit/favorites_cubit.dart';
import 'package:alexandria/favorites/favorites_cubit/favorites_state.dart';
import 'package:alexandria/favorites/repository/favorites_repository.dart';
import 'package:alexandria/repository/models/book.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFavoritesRepository extends Mock implements FavoritesRepository {}

void main() {
  final List<Book> mockBooks = [
    Book(
      id: 0,
      title: 'title 0',
      author: 'author 0',
      description: 'description 0',
      image:
          'https://storage.googleapis.com/du-prd/books/images/9781501183058.jpg',
      publicationDate: DateTime(0),
    ),
    Book(
      id: 1,
      title: 'title 1',
      author: 'author 1',
      description: 'description 1',
      image:
          'https://storage.googleapis.com/du-prd/books/images/9781501183058.jpg',
      publicationDate: DateTime(1),
    ),
    Book(
      id: 2,
      title: 'title 2',
      author: 'author 2',
      description: 'description 2',
      image:
          'https://storage.googleapis.com/du-prd/books/images/9781501183058.jpg',
      publicationDate: DateTime(2),
    ),
  ];

  group('FavoritesCubit', () {
    late FavoritesRepository favoritesRepository;

    setUp(() {
      favoritesRepository = MockFavoritesRepository();

      when(() => favoritesRepository.getFavoritesIds()).thenReturn([0]);
    });

    FavoritesCubit buildBloc() {
      return FavoritesCubit(favoritesRepository);
    }

    group('constructor', () {
      test('works properly', () => expect(buildBloc, returnsNormally));

      test('has correct initial state', () {
        expect(
          buildBloc().state,
          equals(const FavoritesState()),
        );
      });
    });

    group('getFavoritesFrom', () {
      blocTest<FavoritesCubit, FavoritesState>(
          'emits state with success status when repository getFavoritesIds is called',
          build: buildBloc,
          act: (bloc) => bloc.getFavoritesFrom(mockBooks),
          expect: () => [
                const FavoritesState(
                  status: FavoritesStatus.loading,
                ),
                FavoritesState(
                  status: FavoritesStatus.success,
                  favorites: [mockBooks[0]],
                ),
              ]);

      blocTest<FavoritesCubit, FavoritesState>(
          'emits state with failure status when repository getFavoriteIds emits error',
          setUp: () {
            when(
              () => favoritesRepository.getFavoritesIds(),
            ).thenThrow(HiveNotInitializedException);
          },
          build: buildBloc,
          act: (bloc) => bloc.getFavoritesFrom(mockBooks),
          expect: () => [
                const FavoritesState(
                  status: FavoritesStatus.loading,
                ),
                const FavoritesState(
                  status: FavoritesStatus.failure,
                  errorMessage: 'Unknown error',
                ),
              ]);
    });
  });
}
