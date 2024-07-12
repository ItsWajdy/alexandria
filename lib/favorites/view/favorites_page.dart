import 'package:alexandria/all_books/all_books.dart';
import 'package:alexandria/theme.dart';
import 'package:alexandria/ui/widgets/book_preview.dart';
import 'package:alexandria/favorites/favorites.dart';
import 'package:alexandria/favorites/favorites_cubit/favorites_state.dart';
import 'package:alexandria/favorites/repository/favorites_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FavoritesCubit(context.read<FavoritesRepository>()),
      child: BlocBuilder<AllBooksCubit, AllBooksState>(
        builder: (context, state) {
          if (state.status.isSuccess) {
            context.read<FavoritesCubit>().getFavoritesFrom(state.allBooks);
            return const FavoritesView();
          } else if (state.status.isFailure) {
            return Center(child: Text(state.errorMessage ?? 'Unknown error'));
          }
          return const Center(child: Text('Fatal error'));
        },
      ),
    );
  }
}

class FavoritesView extends StatelessWidget {
  const FavoritesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AlexandriaTheme.backgroundColor,
      appBar: AppBar(),
      body: BlocBuilder<FavoritesCubit, FavoritesState>(
        builder: (context, state) {
          if (state.status.isSuccess) {
            return GridView.builder(
              shrinkWrap: true,
              primary: false,
              itemCount: state.favorites.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, mainAxisExtent: 340),
              itemBuilder: (_, index) {
                return BookPreview(
                  book: state.favorites[index],
                );
              },
            );
          } else if (state.status.isFailure) {
            return Center(child: Text(state.errorMessage ?? 'Unknown error'));
          }
          return const SizedBox();
        },
      ),
    );
  }
}
