import 'package:alexandria/favorites/edit_favorites_cubit/edit_favorites_cubit.dart';
import 'package:alexandria/favorites/repository/favorites_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFavoritesRepository extends Mock implements FavoritesRepository {}

void main() {
  group('EditFavoritesCubit', () {
    late FavoritesRepository favoritesRepository;

    setUp(() {
      favoritesRepository = MockFavoritesRepository();

      when(() => favoritesRepository.isBookInFavorites(any()))
          .thenReturn(false);
      when(() => favoritesRepository.addIdToFavorites(any()))
          .thenAnswer((_) async {});
      when(() => favoritesRepository.removeIdFromFavorites(any()))
          .thenAnswer((_) async {});
    });

    EditFavoritesCubit buildBloc() {
      return EditFavoritesCubit(favoritesRepository, 0);
    }

    group('constructor', () {
      test('works properly', () => expect(buildBloc, returnsNormally));

      test('has correct initial state', () {
        expect(
          buildBloc().state,
          equals(const EditFavoritesState()),
        );
      });
    });

    group('flipFavoriteStatus', () {
      blocTest<EditFavoritesCubit, EditFavoritesState>(
          'emits state with success status when repository addIdToFavorites',
          build: buildBloc,
          act: (bloc) => bloc.flipFavoriteStatus(),
          expect: () => [
                const EditFavoritesState(
                  success: true,
                  isBookInFavorites: true,
                ),
              ]);

      blocTest<EditFavoritesCubit, EditFavoritesState>(
          'emits state with success status when repository removeIdFromFavorites',
          setUp: () {
            when(
              () => favoritesRepository.isBookInFavorites(any()),
            ).thenReturn(true);
          },
          build: buildBloc,
          act: (bloc) => bloc.flipFavoriteStatus(),
          expect: () => [
                const EditFavoritesState(
                  success: true,
                  isBookInFavorites: false,
                ),
              ]);

      blocTest<EditFavoritesCubit, EditFavoritesState>(
          'emits state with failure status when repository throws error',
          setUp: () {
            when(
              () => favoritesRepository.addIdToFavorites(any()),
            ).thenThrow(BookNotInFavorites);
          },
          build: buildBloc,
          act: (bloc) => bloc.flipFavoriteStatus(),
          expect: () => [
                const EditFavoritesState(
                    success: false, errorMessage: 'Unknown error'),
              ]);
    });
  });
}
